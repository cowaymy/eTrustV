package com.coway.trust.web.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.eAccounting.creditCard.CreditCardService;
import com.coway.trust.web.eAccounting.pettyCash.PettyCashController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/creditCard")
public class CreditCardController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private CreditCardService creditCardService;
	
	@RequestMapping(value = "/creditCardMgmt.do")
	public String creditCardMgmt(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagement";
	}
	
	@RequestMapping(value = "/selectCrditCardMgmtList.do")
	public ResponseEntity<List<EgovMap>> selectCrditCardMgmtList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] crditCardStus = request.getParameterValues("crditCardStus");
		
		params.put("crditCardStus", crditCardStus);
		
		List<EgovMap> mgmtList = creditCardService.selectCrditCardMgmtList(params);
		
		return ResponseEntity.ok(mgmtList);
	}

}
