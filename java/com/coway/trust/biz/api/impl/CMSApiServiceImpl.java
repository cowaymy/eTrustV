package com.coway.trust.biz.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
/*import com.coway.trust.api.project.CMS.CMSCntcCsvHandler;
*/
import com.coway.trust.biz.api.CMSApiService;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.web.common.claim.FileInfoVO;
import com.coway.trust.web.common.claim.FormDef;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.UserInfo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CMSApiService")
public class CMSApiServiceImpl extends EgovAbstractServiceImpl implements CMSApiService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CMSApiServiceImpl.class);

    @Resource(name = "CMSApiMapper")
    private CMSApiMapper cmsApiMapper;

    @Autowired
    private LargeExcelService largeExcelService;

    @Value("${autodebit.file.upload.path}")
    private String filePath;

    @Value("${cms.host.bastion}")
    private String bastionHost;

    @Value("${cms.host.bastionuser}")
    private String bastionUser;

    @Value("${cms.host.bastionpassword}")
    private String bastionPassword;

    @Value("${cms.host.cicd}")
    private String cicdHost;

    @Value("${cms.host.sftpuser}")
    private String sftpUser;

    @Value("${cms.host.sftppassword}")
    private String sftpPassword;

    @Value("${cms.host.sftpdest}")
    private String sftpDest;

    @Value("${cms.host.knownhost}")
    private String knownHost;

    private String[] cntcCsvColumns = new String[] {
            "id", "type", "memCodeId", "cntcId", "addId",
            "ordCat", "name", "dob", "mobileNo", "officeNo",
            "residenceNo", "email", "subType", "corpType", "address",
            "cnty", "postCode", "crtDt", "updDt"
    };

    @Override
    public EgovMap genCsvFile(HttpServletRequest request, Map<String, Object> params) throws Exception {
        LOGGER.info("=============== genCsvFile ===============");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("date", df.format(date));

        // Test block - JSch connection to Bastion > CICD Instance - Start
        // TODO - remove after test
//        String subPath = "C:\\works\\workspace\\etrust\\src\\main\\webapp\\resources\\WebShare\\CRT\\resources\\WebShare\\API\\CMS20220418\\";
//        String file = "Test.csv";
//        map.put("subPath", subPath);
//        map.put("file", file);
//
//        sshPushFile(map);
        // Test block - JSch connection to Bastion > CICD Instance - End

        // Actual working block - Start
        int rowCnt = cmsApiMapper.getRowCount(map);
        int pages = rowCnt/1000000;

        if(pages > 0) {
            /*
             * Loop number of new records inserted into API0008D by 1,000,000
             * 1. Creates CSV file
             * 2. Push file via JSch + SFTP
             * Reference : https://blog.gordonturner.com/2017/04/09/creating-a-ssh-tunnel-in-java/
             */
            for(int i = 1; i <= pages; i++) {
                map.put("page", i);
                map.put("rowCnt", 1000000);
                this.createCsvFile(map);
            }
        }
        // Actual working block - End

        return null;
    }

    private void createCsvFile(Map<String, Object> map) throws Exception {
        LOGGER.info("=============== createCsvFile ===============");
/*        CMSCntcCsvHandler fileHandler = null;
*/
//        String path = "/apps/apache/htdocs/resources/WebShare/CRT";
        String subPath = "/resources/WebShare/API/CMS";
        String file = "CMS_CONTACT_" + map.get("date").toString() + "_" + map.get("page") + ".csv";

        map.put("subPath", subPath);
        map.put("file", file);

        try {
/*            fileHandler = getCmsCntcCsvHandler(file, cntcCsvColumns, null, filePath, subPath + map.get("date").toString() + "/", map);
*/
/*            largeExcelService.downloadCmsCntcCsv(map, fileHandler);
*/
            map.put("fileDir", subPath + map.get("date").toString() + "/" + file);
            sshPushFile(map);

        } catch(Exception ex) {
            throw new ApplicationException(ex, AppConstants.FAIL);
        } finally {
/*            if(fileHandler != null) {
                try {
                    fileHandler.close();
                } catch(Exception ex) {
                    LOGGER.error(ex.getMessage());
                }
            }*/
        }
    }

/*    private CMSCntcCsvHandler getCmsCntcCsvHandler(String fileName, String[] columns, String[] titles, String path, String subPath, Map<String, Object> params) {
        FileInfoVO downloadVo = FormDef.getTextDownloadVO(fileName, columns, titles);
        downloadVo.setFilePath(path);
        downloadVo.setSubFilePath(subPath);
        return new CMSCntcCsvHandler(downloadVo, params);
    }*/

    private void sshPushFile(Map<String, Object> map) {
        LOGGER.info("========== sshPushFile ==========");
        // Reference :: https://blog.gordonturner.com/2017/04/09/creating-a-ssh-tunnel-in-java/

        final int SESS_TIMEOUT = 10000;

        // For testing
        //String upFile = map.get("subPath").toString() + map.get("file").toString();

        Session session_b = null; // Bastion Session
        Session session_c = null; // CICD Session

        ChannelSftp sftp = null;

        try {
            JSch jsch = new JSch();

            //File file = new File(upFile); // For testing
            File file = new File(map.get("fileDir").toString());
            InputStream isFile = new FileInputStream(file);

            // SSH Bastion
            jsch.setKnownHosts(knownHost);
            session_b = jsch.getSession(bastionUser, bastionHost, 22);
            session_b.setPassword(bastionPassword);
            java.util.Properties config_b = new java.util.Properties();
            config_b.put("server_host_key", "ecdsa-sha2-nistp256");
            session_b.setConfig(config_b);
            session_b.setTimeout(SESS_TIMEOUT);
            session_b.connect(SESS_TIMEOUT);
            LOGGER.info("Connected to :: " + bastionUser + "@" + bastionHost);

            // JumpHost
            int assignedPort = session_b.setPortForwardingL(0, cicdHost, 22);
            LOGGER.info("portForwardingL :: " + bastionUser + "@" + cicdHost + " - assignedPort :: " + assignedPort);

            // SSH CICD
            jsch.setKnownHosts(knownHost);
            session_c = jsch.getSession(sftpUser, "127.0.0.1", assignedPort);
            session_c.setHostKeyAlias(cicdHost);
            session_c.setPassword(sftpPassword);
            java.util.Properties config_c = new java.util.Properties();
            config_c.put("server_host_key", "ecdsa-sha2-nistp256");
            // This part is required as of this development as it will hit unknown host error connecting to CICD
            config_c.put("StrictHostKeyChecking", "no");
            session_c.setConfig(config_c);
            session_c.setTimeout(SESS_TIMEOUT);
            session_c.connect(SESS_TIMEOUT);
            LOGGER.info("Connected to :: " + sftpUser + "@" + cicdHost);

            sftp = (ChannelSftp)session_c.openChannel("sftp");
            sftp.connect();
            // List directory
            /*
            sftp.ls(".",
                    new ChannelSftp.LsEntrySelector() {
                      public int select(ChannelSftp.LsEntry le) {
                        System.out.println(le);
                        return ChannelSftp.LsEntrySelector.CONTINUE;
                      }
                    });
            */
//            sftp.cd("/sftp_user/cms-contact");
//            sftp.put(isFile, "/sftp_user/cms-contact/" + map.get("file").toString());
            sftp.put(isFile, sftpDest + map.get("file").toString());

        } catch(Exception e) {
            LOGGER.error(e.toString());
            e.printStackTrace();

        } finally {
            if(sftp != null) sftp.disconnect();
            if(session_c != null) session_c.disconnect();
            if(session_b != null) session_b.disconnect();
        }
    }
}
