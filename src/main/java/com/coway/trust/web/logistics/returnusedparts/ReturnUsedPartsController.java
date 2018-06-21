package com.coway.trust.web.logistics.returnusedparts;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.biz.logistics.totalstock.TotalStockService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/returnusedparts")
public class ReturnUsedPartsController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "returnUsedPartsService")
	private ReturnUsedPartsService returnUsedPartsService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/ReturnUsedParts.do")
	public String totalstock(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/returnUsedParts/returnUsedPartsList";
	}
	
	
	@RequestMapping(value = "/ReturnUsedPartsTest.do")
	public ResponseEntity<ReturnMessage> returnUsedPartsTest(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String str = request.getParameter("param");

		returnUsedPartsService.returnPartsInsert(str);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
		
	}
	
	@RequestMapping(value = "/ReturnUsedPartsDelTest.do")
	public ResponseEntity<ReturnMessage> returnUsedPartsDelTest(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String str = request.getParameter("param");

		returnUsedPartsService.returnPartsdelete(str);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
		
	}
	
	
	@RequestMapping(value = "/returnPartsSearchList.do", method = RequestMethod.GET)
		public ResponseEntity<Map> returnPartsList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String searchOder = request.getParameter("searchOder");
		String searchCustomer = request.getParameter("searchCustomer");
		String searchMaterialCode = request.getParameter("searchMaterialCode");
		
		String servicesdt   = request.getParameter("servicesdt");
		String serviceedt = request.getParameter("serviceedt");
		String returnsdt   = request.getParameter("returnsdt");
		String returnedt = request.getParameter("returnedt");
		String searchMaterialType   = request.getParameter("searchMaterialType");
		String searchComplete = request.getParameter("searchComplete");
		String[] searchLoc = request.getParameterValues("searchLoc");
		
		logger.debug("searchOder    값 : {}", searchOder);
		logger.debug("searchCustomer    값 : {}", searchCustomer);
		logger.debug("searchMaterialCode    값 : {}", searchMaterialCode);
		logger.debug("servicesdt    값 : {}", servicesdt);
		logger.debug("serviceedt    값 : {}", serviceedt);
		logger.debug("returnsdt    값 : {}", returnsdt);
		logger.debug("returnedt    값 : {}", returnedt);
		logger.debug("searchMaterialType    값 : {}", searchMaterialType);
		logger.debug("searchComplete    값 : {}", searchComplete);
		logger.debug("searchLoc  !!!!!  값 : {}", searchLoc);
		
		
		Map<String, Object> smap = new HashMap();
		
		smap.put("searchOder", searchOder);
		smap.put("searchCustomer", searchCustomer);
		smap.put("searchMaterialCode", searchMaterialCode);
		smap.put("servicesdt", servicesdt);
		smap.put("serviceedt", serviceedt);
		smap.put("returnsdt", returnsdt);
		smap.put("returnedt", returnedt);
		smap.put("searchMaterialType", searchMaterialType);
		smap.put("searchComplete", searchComplete);
		smap.put("searchLoc", searchLoc);
		
		logger.debug("smap    값 : {}", smap);
		
		List<EgovMap> list = returnUsedPartsService.returnPartsList(smap);
		
		for (int i = 0; i < list.size(); i++) {
			logger.debug("Return Used Parts List       값 : {}",list.get(i));
		}
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/returnPartsUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> returnPartsUpdate(@RequestBody Map<String, Object> params, Model model) {


		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		 logger.debug("loginId@@@@@: {}", loginId);
	
		 
		 List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		 Map<String, Object> insMap = new HashMap<>();
		 int dupCnt =0;
		 
		 
			for (int i = 0; i < checkList.size(); i++) {
				logger.debug("checkList    값 : {}", checkList.get(i));
			}
			
			if (checkList.size() > 0) {
				for (int i = 0; i < checkList.size(); i++) {
					 insMap = (Map<String, Object>) checkList.get(i);
				}
				 dupCnt = returnUsedPartsService.returnPartsdupchek(insMap);		
			}
			
			logger.debug("dupCnt %$%$%$%$%$%$ ??????: {}", dupCnt);
			
		 if(dupCnt == 0){
			 returnUsedPartsService.returnPartsUpdate(params,loginId);
		 }

		

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(dupCnt);

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/returnPartsCanCle.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> returnPartsCanCle(@RequestBody Map<String, Object> params, Model model) {


		 returnUsedPartsService.returnPartsCanCle(params);

		// logger.debug("posSeq@@@@@: {}", posSeq);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	
	@RequestMapping(value = "/validMatCodeSearch.do" ,method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> validMatCodeSearch(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String matcode = request.getParameter("matcode");
		
		 logger.debug("matcode@@@@@@@@: {}", matcode);
		
		int matcodeCnt = returnUsedPartsService.validMatCodeSearch(matcode);
		
		logger.debug("matcodeCnt %$%$%$%$%$%$: {}", matcodeCnt);
		
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(matcodeCnt);
		
		return ResponseEntity.ok(message);
		
	}
	
	@RequestMapping(value="/HSUsedFilterListingPop.do")
	public String HSUsedFilterListingPop(){
		
		return "logistics/returnUsedParts/HSUsedFilterListingPop";
	}
	
	@RequestMapping(value="/getDeptCodeList")
	public ResponseEntity<List<EgovMap>> getDeptCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> deptCodeList = null;
		deptCodeList = returnUsedPartsService.getDeptCodeList(params);
		
		return ResponseEntity.ok(deptCodeList);
	}
	
	@RequestMapping(value="/getCodyCodeList")
	public ResponseEntity<List<EgovMap>> getCodyCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> codyCodeList = null;
		codyCodeList = returnUsedPartsService.getCodyCodeList(params);
		
		return ResponseEntity.ok(codyCodeList);
	}
	
	@RequestMapping(value = "/selectBranchCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> branchCodeList = returnUsedPartsService.selectBranchCodeList(params);
		return ResponseEntity.ok(branchCodeList);
	}
	
	
}
