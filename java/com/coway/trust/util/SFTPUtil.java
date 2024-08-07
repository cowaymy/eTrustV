package com.coway.trust.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

public class SFTPUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(SFTPUtil.class);

    /**
     * 서버와 연결하여 파일을 업로드하고, 다운로드한다.
     *
     */
	private Session session = null;
	private Channel channel = null;
    private ChannelSftp channelSftp = null;

    private int timeout = 0;


    /**
     * 서버와 연결에 필요한 값들을 가져와 초기화 시킴
     *
     * @param host
     *            서버 주소
     * @param userName
     *            접속에 사용될 아이디
     * @param password
     *            비밀번호
     * @param port
     *            포트번호
     */
    public void init(String host, String userName, String password, int port) {
        JSch jsch = new JSch();
        try {
            session = jsch.getSession(userName, host, port);
            session.setPassword(password);

            session.setTimeout(timeout);

            LOGGER.debug(">>>>>>>Cipher:::" + session.getConfig("Cipher"));
            LOGGER.debug(">>>>>>>kex:::" + session.getConfig("kex"));

            //session.getConfig("kex")

            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            //config.put("kex", "diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256");


            //config.put("Cipher", "blowfish-cbc,3des-cbc,aes128-cbc,aes192-cbc,aes256-cbc,aes128-ctr,aes192-ctr,aes256-ctr,3des-ctr,arcfour,arcfour128,arcfour256");
            //config.put("kex", "diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha256,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521");
            session.setConfig(config);

            LOGGER.debug(">>>>>>>kex:::" + session.getConfig("kex"));
            session.connect();

            LOGGER.debug(">>>>>>>after session.connect");

            channel = session.openChannel("sftp");
            LOGGER.debug(">>>>>>>after sftp openChannel");
            channel.connect();
            LOGGER.debug(">>>>>>>after channel.connect");
        } catch (JSchException e) {
            //e.printStackTrace();
        	LOGGER.error("e", e);
        }

        channelSftp = (ChannelSftp) channel;

    }

    /**
     * 인자로 받은 경로의 파일 리스트를 리턴한다.
     * @param path
     * @return
     */
    public Vector<ChannelSftp.LsEntry> getFileList(String path) {

    	Vector<ChannelSftp.LsEntry> list = null;
    	try {
    		channelSftp.cd(path);
    		//LOGGER.debug(" pwd : " + channelSftp.pwd());
    		list = channelSftp.ls(".");
    	} catch (SftpException e) {
    		//e.printStackTrace();
    		LOGGER.error("e", e);
    		return null;
    	}

    	return list;
    }

    /**
     * 하나의 파일을 업로드 한다.
     *
     * @param dir
     *            저장시킬 주소(서버)
     * @param file
     *            저장할 파일
     */
    public boolean upload(String dir, File file) {

        FileInputStream in = null;
        try {
            in = new FileInputStream(file);
            channelSftp.cd(dir);
            channelSftp.put(in, file.getName());
        } catch (SftpException e) {
            //e.printStackTrace();
        	LOGGER.error("e", e);

        	return false;

        } catch (FileNotFoundException e) {
            //e.printStackTrace();
        	LOGGER.error("e", e);

        	return false;

        } finally {
            try {
            	if(in != null){
            		in.close();
            	}

            } catch (IOException e) {
                //e.printStackTrace();
            	LOGGER.error("e", e);

                return false;
            }
        }

        return true;
    }

    /**
     * 하나의 파일을 다운로드 한다.
     *
     * @param dir
     *            저장할 경로(서버)
     * @param downloadFileName
     *            다운로드할 파일
     * @param path
     *            저장될 공간
     */
    public boolean download(String dir, String downloadFileName, String path) {
        InputStream in = null;
        FileOutputStream out = null;
        try {
            channelSftp.cd(dir);
            in = channelSftp.get(downloadFileName);
        } catch (SftpException e) {
            // TODO Auto-generated catch block
            //e.printStackTrace();
        	LOGGER.error("e", e);

        	return false;
        }

        try {
            out = new FileOutputStream(new File(path));
            int i;

            while ((i = in.read()) != -1) {
                out.write(i);
            }

        } catch (IOException e) {
            // TODO Auto-generated catch block
            //e.printStackTrace();
        	LOGGER.error("e", e);

        	return false;

        } finally {
            try {
                out.close();
                in.close();

            } catch (IOException e) {
                //e.printStackTrace();
            	LOGGER.error("e", e);

            	return false;
            }

        }


        return true;

    }

    /**
     * 서버와의 연결을 끊는다.
     */
    public void disconnection() {
    	if(channelSftp != null){
    		channelSftp.quit();
    	}

    }

    public boolean move(String originalPath, String destinationPath, String fileName){
    	try{
    		channelSftp.cd(originalPath);
    		if(channelSftp.get(fileName) != null){
    			channelSftp.rename(originalPath + fileName, destinationPath + fileName);
    		}

    		return true;
    	}catch(Exception e){
//    		e.printStackTrace();
    		LOGGER.error("e",e);
    		return false;
    	}
    }

}