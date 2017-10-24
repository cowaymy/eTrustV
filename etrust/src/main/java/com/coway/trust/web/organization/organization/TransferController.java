package com.coway.trust.web.organization.organization;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.organization.organization.TransferService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class TransferController {
	private static final Logger logger = LoggerFactory.getLogger(TransferController.class);
	
	@Resource(name = "transferService")
	private TransferService transferService;
	@Resource(name = "commonService")
	private CommonService commonService;
	
	
	/**
	 * organization transfer page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/transfer.do")
	public String transferPageOpen(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "organization/organization/transfer";
	}
	
	/**
	 * organization transfer MemberLevel 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberLevel.do" ,method = RequestMethod.GET)
	public  ResponseEntity<List<EgovMap>> selectMemberLevel(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params : {}", params);
		params.put("memberType", params.get("groupCode"));
		List<EgovMap> memberLevel  = transferService.selectMemberLevel(params);
		logger.debug("memberLevel : {}", memberLevel);
		// 호출될 화면
		return ResponseEntity.ok(memberLevel);
	}
	
	/**
	 * organization transfer From Transfer 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectFromTransfer.do" ,method = RequestMethod.GET)
	public  ResponseEntity<List<EgovMap>> selectFromTransfer(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug(" selectFromTransfer params : {}", params);
		params.put("memberType", params.get("groupCode[memberType]"));
		params.put("memberLevel", params.get("groupCode[memberLevel]"));
		List<EgovMap> selectFromTransfer  = transferService.selectFromTransfer(params);
		logger.debug("selectFromTransfer : {}", selectFromTransfer);
		// 호출될 화면
		return ResponseEntity.ok(selectFromTransfer);
	}
	
	/**
	 * organization transfer From Transfer 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransferList.do" ,method = RequestMethod.GET)
	public  ResponseEntity<List<EgovMap>> selectTransferList(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug(" selectTransferList params : {}", params);
		params.put("memberType", params.get("groupCode[memberType]"));
		params.put("memberUpId", params.get("groupCode[memberUpId]"));
		List<EgovMap> selectTransferList  = transferService.selectTransferList(params);
		logger.debug("selectTransferList : {}", selectTransferList);
		// 호출될 화면
		return ResponseEntity.ok(selectTransferList);
	}
	
	/**
	 * organization transfer From Transfer 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTransfer.do" ,method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> insertTransfer(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request,SessionVO sessionVo){
		boolean success = false;
		ReturnMessage message = new ReturnMessage();
		logger.debug(" insertTransfer params : {}", params);
		success = transferService.insertTransferMember(params,sessionVo);
		
		if(success){
			message.setMessage("Complete to Transfer Member Code : <br/> " + params.get("selectText"));
		}else{
			message.setMessage("Fail to Transfer Member Code : <br/> " + params.get("selectText"));
		}
		// 호출될 화면
		return ResponseEntity.ok(message);
	}
}
