/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package deu.cse.spring_webmail;

import java.io.File;

/**
 * 시스템에서 일정 시간마다 진행되는 함수들을 작성
 * @author User
 */
public class AutoSystem {
    
    
    
    /**
     * download폴더에서 README.txt파일을 제외한 폴더들을 리스트화 시킨다.
     */
    public void searchDelFile(){
        String downloadPath = String.format("%s\\src\\main\\webapp\\WEB-INF\\download", System.getProperty("user.dir"));
        File[] file = new File(downloadPath).listFiles();
        
        for(File fileName : file){
            if(fileName.isDirectory())
                delFile(fileName.getAbsolutePath());
        }
    }
    
    /**
     * download폴더에 있는 파일 삭제
     * 재귀함수를 통하여 폴더내에 파일이 존재하면 삭제를 거듭하여 파일을 삭제한다.
     * @param path 
     */
    private void delFile(String path){
        File file = new File(path);
        File[] fileList = file.listFiles();
        
        for(File f : fileList){
            if(f.isFile()){
                f.delete();
            }else{
                delFile(f.getAbsolutePath());
            }
        }
        file.delete();
    }
}
