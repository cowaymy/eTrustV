package com.coway.trust.biz.sales.customer.impl;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.customer.CustomerCRCService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.SFTPUtil;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerCRCService")
public class CustomerCRCServiceImpl extends EgovAbstractServiceImpl implements CustomerCRCService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CustomerServiceImpl.class);

    @Resource(name = "customerCRCMapper")
    private CustomerCRCMapper customerCRCMapper;

    public void createBatchCSV(Map<String, Object> params) {
        LOGGER.error("DEBUG :: createBatchCSV :: start");
        LOGGER.error("DEBUG :: createBatchCSV :: {}", params.toString());

        // ========================
        // Create CSV file :: Start
        // ========================
        String fileDir, fileName;
        BufferedWriter fileWriter = null;

        fileDir = params.get("fileDir").toString() + "/BatchToken";
        fileName = "[MCP]_Batch_Migration_" + CommonUtils.getNowDate() + ".csv";

        try {
            File file = new File(fileDir + "/" + fileName);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            fileWriter = new BufferedWriter(new FileWriter(file));

            List<EgovMap> cardDetailsList = customerCRCMapper.getCardDetails();

            Map<String, Object> cardDetailsMap = new HashMap<String, Object>();
            for(Map<String, Object> cardObject : cardDetailsList) {
                cardDetailsMap.putAll(cardObject);

                String refNo = cardDetailsMap.get("refno").toString();
                String crcNo = cardDetailsMap.get("custCrcNo").toString();
                String crcExpr = cardDetailsMap.get("custCrcExpr").toString();

                String lineDtl = refNo + "," + crcNo + "," + crcExpr;

                fileWriter.write(lineDtl);
                fileWriter.newLine();
                fileWriter.flush();
            }
        } catch(Exception ex) {
            LOGGER.error(ex.toString());
        } finally {
            if(fileWriter != null) {
                try {
                    fileWriter.close();
                } catch (IOException ex) {
                    LOGGER.error(ex.toString());
                }
            }
        }

        // ======================
        // Create CSV file :: End
        // ======================

        // ==================
        // SFTP File :: Start
        // ==================
        String host, port, userName, password, sftpDir;

        host = params.get("sftpHost").toString();
        port = params.get("sftpPort").toString();
        userName = params.get("sftpUserId").toString();
        password = params.get("sftpUserPw").toString();
        sftpDir = params.get("sftpPath").toString();

        SFTPUtil util = new SFTPUtil();
        util.init(host, userName, password, Integer.parseInt(port));

//        try {
//            JSch jsch = new JSch();
//            Session session = jsch.getSession(userName, host);
//            session.setPassword(password);
//            session.connect();
//
//            ChannelSftp sftpChannel = (ChannelSftp) session.openChannel("sftp");
//            sftpChannel.connect();
//        } catch(Exception ex) {
//            LOGGER.error(ex.toString());
//        }

        File file = new File(fileDir + "/" + fileName);
        LOGGER.error("createBatchCSV :: " + file.getAbsolutePath());

        boolean b1 = util.upload(sftpDir, file);
        LOGGER.error(Boolean.toString(b1));
        if(!b1) {
            LOGGER.error("createBatchCSV :: SFTP Failed :: " + fileName);
        }

        util.disconnection();
        // ================
        // SFTP File :: End
        // ================
    }

}
