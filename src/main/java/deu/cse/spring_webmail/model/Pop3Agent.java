/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package deu.cse.spring_webmail.model;

import jakarta.mail.Flags;
import jakarta.mail.Folder;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Store;
import jakarta.mail.internet.MimeMessage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.PropertySource;

/**
 *
 * @author skylo
 */
@Slf4j
@NoArgsConstructor        // 기본 생성자 생성
@PropertySource(value = "classpath:/application.properties")
public class Pop3Agent {

    @Getter
    @Setter
    private String host;
    @Getter
    @Setter
    private String userid;
    @Getter
    @Setter
    private String password;
    @Getter
    @Setter
    private Store store;
    @Getter
    @Setter
    private String excveptionType;
    @Getter
    @Setter
    private HttpServletRequest request;

    // 220612 LJM - added to implement REPLY
    @Getter
    private String sender;
    @Getter
    private String subject;
    @Getter
    private String body;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    public Pop3Agent(String host, String userid, String password) {
        this.host = host;
        this.userid = userid;
        this.password = password;
    }

    public boolean validate() {
        boolean status = false;

        try {
            status = connectToStore();
            store.close();
        } catch (Exception ex) {
            log.error("Pop3Agent.validate() error : " + ex);
            status = false;  // for clarity
        } finally {
            return status;
        }
    }

    public boolean deleteMessage(int msgid, boolean really_delete) {
        boolean status = false;

        if (!connectToStore()) {
            return status;
        }

        try {
            // Folder 설정
//            Folder folder = store.getDefaultFolder();
            Folder folder = store.getFolder("INBOX");
            folder.open(Folder.READ_WRITE);

            // Message에 DELETED flag 설정
            Message msg = folder.getMessage(msgid);
            msg.setFlag(Flags.Flag.DELETED, really_delete);

            // 폴더에서 메시지 삭제
            // Message [] expungedMessage = folder.expunge();
            // <-- 현재 지원 안 되고 있음. 폴더를 close()할 때 expunge해야 함.
            folder.close(true);  // expunge == true
            store.close();
            status = true;
        } catch (Exception ex) {
            log.error("deleteMessage() error: {}", ex.getMessage());
        } finally {
            return status;
        }
    }

    /*
     * 페이지 단위로 메일 목록을 보여주어야 함.
     */
     public ArrayList<MessageFormatter> getMessageList(HikariConfiguration dbConfig) {
        //컨트롤러에서 dbConfig 정보를 받아와서 사용

        ArrayList<MessageFormatter> list = new ArrayList<>();
        MessageFormatter formatter = new MessageFormatter(userid);  //3.5
        ArrayList<Message> messages = new ArrayList<>();

        try {
            //DB에서 메시지 값을 가져와서 읽기
            //inbox에서 메일 정복가 있는 message_body를 불러와서 처리
            String sql = "SELECT message_body, message_name from inbox where repository_name=?";
            javax.sql.DataSource ds = dbConfig.dataSouce();
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            log.debug("sql = {}", pstmt);
            rs = pstmt.executeQuery();

            // 메일 읽음 여부를 확인하기 위해 read_mail 테이블에 사용자가 받은 메일이 없는 경우 추가
            String insertSql = "INSERT INTO read_mail (message_name) SELECT ? WHERE NOT EXISTS (SELECT 1 FROM read_mail WHERE message_name = ?)";
            PreparedStatement insert_pstmt = conn.prepareStatement(insertSql);

            MimeMessage mimeMessage = null;

            int co = 0;
            while (rs.next()) {
                String message_name = rs.getString("message_name");

                insert_pstmt.setString(1, message_name);
                insert_pstmt.setString(2, message_name);
                insert_pstmt.addBatch();

                //Message 객체에 담을 수 있도록 message_body를 사용하여 MimeMessage 객체 사용
                mimeMessage = new MimeMessage(Session.getDefaultInstance(System.getProperties()), rs.getBlob("message_body").getBinaryStream());
                //messages[co] = mimeMessage;
                messages.add(mimeMessage);
                co++;
            }
            insert_pstmt.executeBatch();
            insert_pstmt.close();

            list = formatter.getMessageTable(messages);
        } catch (MessagingException | SQLException ex) {
            log.error("Pop3Agent.getMessageList() : exception = {}", ex.getMessage());
        } finally {
            return list;
        }
    }
     
     // 읽은 메일을 추출하기 위함
      public ArrayList<String> ReadCheck(HikariConfiguration dbConfig) {
        ArrayList<String> r_check = new ArrayList<>();
        try {
            String sql = "SELECT r.message_name FROM inbox as i JOIN read_mail as r ON i.message_name=r.message_name WHERE i.repository_name=? and r.read_check=1";
            javax.sql.DataSource ds = dbConfig.dataSouce();
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            log.debug("sql = {}", pstmt);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String messageName = rs.getString("r.message_name");
                r_check.add(messageName);
            }

        } catch (SQLException ex) {
            log.error("read_mail check sql 오류() : execption={}", ex.getMessage());
        } finally {
            return r_check;
        }
    }

    // 메일 읽음 확인을 위해 사용자가 받은 메일 추출
    public ArrayList<String> GetMessageId(HikariConfiguration dbConfig) {
        ArrayList<String> get_id = new ArrayList<>();
        try {
            String sql = "SELECT message_name FROM inbox WHERE repository_name=?";
            javax.sql.DataSource ds = dbConfig.dataSouce();
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            log.debug("sql = {}", pstmt);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String messageName = rs.getString("message_name");
                get_id.add(messageName);
            }

        } catch (SQLException ex) {
            log.error("GetMessageId sql 오류() : execption={}", ex.getMessage());
        } finally {
            return get_id;
        }
    }

    // 보낸 메일함
    public ArrayList<MessageFormatter> getSentMessageList(HikariConfiguration dbConfig) {

        ArrayList<MessageFormatter> list = new ArrayList<>();
        MessageFormatter formatter = new MessageFormatter(userid);  //3.5
        ArrayList<Message> messages = new ArrayList<>();

        try {

            String sql = "SELECT message_body from inbox where sender=?";  
            javax.sql.DataSource ds = dbConfig.dataSouce();
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid + "@localhost");
            log.debug("sql = {}", pstmt);
            rs = pstmt.executeQuery();
            MimeMessage mimeMessage = null;

            int co = 0;
            while (rs.next()) {
                mimeMessage = new MimeMessage(Session.getDefaultInstance(System.getProperties()), rs.getBlob("message_body").getBinaryStream());
                messages.add(mimeMessage);
                co++;
            }
            list = formatter.getSentMessageTable(messages);
        } catch (MessagingException | SQLException ex) {
            log.error("Pop3Agent.getMessageList() : exception = {}", ex.getMessage());
        } finally {
            return list;
        }
    }

    public String getMessage(int n) {
        String result = "POP3  서버 연결이 되지 않아 메시지를 볼 수 없습니다.";

        if (!connectToStore()) {
            log.error("POP3 connection failed!");
            return result;
        }

        try {
            Folder folder = store.getFolder("INBOX");
            folder.open(Folder.READ_ONLY);

            Message message = folder.getMessage(n);
            MessageFormatter formatter = new MessageFormatter(userid);
            formatter.setRequest(request);  // 210308 LJM - added
            result = formatter.getMessage(message);
            sender = formatter.getSender();  // 220612 LJM - added
            subject = formatter.getSubject();
            body = formatter.getBody();

            folder.close(true);
            store.close();
        } catch (Exception ex) {
            log.error("Pop3Agent.getMessageList() : exception = {}", ex);
            result = "Pop3Agent.getMessage() : exception = " + ex;
        } finally {
            return result;
        }
    }

    private boolean connectToStore() {
        boolean status = false;
        Properties props = System.getProperties();
        // https://jakarta.ee/specifications/mail/2.1/apidocs/jakarta.mail/jakarta/mail/package-summary.html
        props.setProperty("mail.pop3.host", host);
        props.setProperty("mail.pop3.user", userid);
        props.setProperty("mail.pop3.apop.enable", "false");
        props.setProperty("mail.pop3.disablecapa", "true");  // 200102 LJM - added cf. https://javaee.github.io/javamail/docs/api/com/sun/mail/pop3/package-summary.html
        props.setProperty("mail.debug", "false");
        props.setProperty("mail.pop3.debug", "false");

        Session session = Session.getInstance(props);
        session.setDebug(false);

        try {
            store = session.getStore("pop3");
            store.connect(host, userid, password);
            status = true;
        } catch (Exception ex) {
            log.error("connectToStore 예외: {}", ex.getMessage());
        } finally {
            return status;
        }
    }

}
