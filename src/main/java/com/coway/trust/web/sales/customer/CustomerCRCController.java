package com.coway.trust.web.sales.customer;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.CustomerCRCService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

@Controller
@RequestMapping(value = "/sales/CustomerCRCController")
public class CustomerCRCController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CustomerCRCController.class);

    @Value("${tokenization.mcp.sftp.host}")
    private String TOKEN_SFTP_HOST;

    @Value("${tokenization.mcp.sftp.port}")
    private String TOKEN_SFTP_PORT;

    @Value("${tokenization.mcp.sftp.userid}")
    private String TOKEN_SFTP_USERID;

    @Value("${tokenization.mcp.sftp.userpw}")
    private String TOKEN_SFTP_USERPW;

    @Value("${tokenization.mcp.sftp.path}")
    private String TOKEN_SFTP_PATH;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @Resource(name = "customerCRCService")
    private CustomerCRCService customerCRCService;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Autowired
    private SessionHandler sessionHandler;

    @RequestMapping(value = "/batchSFTP.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<ReturnMessage> batchSFTP(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.error("DEBUG :: Tokenization :: Batch SFTP :: Start");
        LOGGER.error("DEBUG :: Tokenization :: Batch SFTP :: {}", params.toString());

        params.put("fileDir", uploadDir);
        params.put("sftpHost", TOKEN_SFTP_HOST);
        params.put("sftpPort", TOKEN_SFTP_PORT);
        params.put("sftpUserId", TOKEN_SFTP_USERID);
        params.put("sftpUserPw", TOKEN_SFTP_USERPW);
        params.put("sftpPath", TOKEN_SFTP_PATH);

        try {
            customerCRCService.createBatchCSV(params);
        } catch (Exception ex) {
            LOGGER.error(ex.toString());
        }

        ReturnMessage message = new ReturnMessage();

        message.setCode(AppConstants.SUCCESS);
        message.setData(0);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
}
