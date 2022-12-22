package com.coway.trust.web.logistics.returnusedparts;

import java.util.ArrayList;
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
import org.springframework.ui.ModelMap;
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


		String searchBranch = request.getParameter("searchBranch");
		String searchCM = request.getParameter("cmdCdManager");
		String searchLoc = request.getParameter("sc");

		String searchSerialChk = request.getParameter("searchSerialChk");
		String searchSerialSts = request.getParameter("searchSerialSts");
		String searchOder = request.getParameter("searchOder");
		String searchComplete = request.getParameter("searchComplete");
		String servicesdt   = request.getParameter("servicesdt");
		String serviceedt = request.getParameter("serviceedt");

		String searchMaterialCode = request.getParameter("searchMaterialCode");
		String searchUsedSerial = request.getParameter("searchUsedSerial");
		String sUnmatchReason = request.getParameter("sUnmatchReason");


		//String[] searchLoc = request.getParameterValues("sc");

		logger.debug("searchCM    값 : {}", searchCM);
		logger.debug("searchOder    값 : {}", searchOder);
		logger.debug("servicesdt    값 : {}", servicesdt);
		logger.debug("serviceedt    값 : {}", serviceedt);
		logger.debug("searchComplete    값 : {}", searchComplete);
		logger.debug("searchLoc  값 : {}", searchLoc);
		logger.debug("searchSerialChk  값 : {}", searchSerialChk);
		logger.debug("searchSerialSts  값 : {}", searchSerialSts);


		Map<String, Object> smap = new HashMap();

		if( !searchBranch.equals("") &&
				(searchCM == null || searchCM.equals("")) &&
				(searchLoc == null  || searchLoc.equals("")) ){
			smap.put("searchBranch", searchBranch);
		}else if( !searchBranch.equals("") &&
				!searchCM.equals("") &&
				(searchLoc == null  || searchLoc.equals("")) ){
			smap.put("searchCM", searchCM);
		}else if(!searchLoc.equals("")){
			smap.put("searchLoc", searchLoc);
		}
		smap.put("searchOder", searchOder);
		smap.put("servicesdt", servicesdt);
		smap.put("serviceedt", serviceedt);
		smap.put("searchComplete", searchComplete);
		smap.put("searchSerialChk", searchSerialChk);
		smap.put("searchSerialSts", searchSerialSts);
		smap.put("searchMaterialCode", searchMaterialCode);
		smap.put("searchUsedSerial", searchUsedSerial);
		smap.put("sUnmatchReason", sUnmatchReason);

		logger.debug("smap    값 : {}", smap);

		List<EgovMap> list = returnUsedPartsService.returnPartsList(smap);

		for (int i = 0; i < list.size(); i++) {
			//logger.debug("Return Used Parts List       값 : {}",list.get(i));
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

	@RequestMapping(value = "/selectSelectedBranchCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSelectedBranchCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> branchCodeList = returnUsedPartsService.selectSelectedBranchCodeList(params);
		return ResponseEntity.ok(branchCodeList);
	}

	@RequestMapping(value = "/returnPartsUpdatePend.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> returnPartsUpdatePend(@RequestBody Map<String, Object> params, Model model) {


		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		 logger.debug("loginId@@@@@: {}", loginId);

		 Map<String, Object> returnResult = returnUsedPartsService.returnPartsUpdatePend(params,loginId);

//		 List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
//		 Map<String, Object> insMap = new HashMap<>();
//		 int dupCnt =0;
//			for (int i = 0; i < checkList.size(); i++) {
//				logger.debug("checkList    값 : {}", checkList.get(i));
//			}
//
//			if (checkList.size() > 0) {
//				for (int i = 0; i < checkList.size(); i++) {
//					 insMap = (Map<String, Object>) checkList.get(i);
//				}
//				 dupCnt = returnUsedPartsService.returnPartsdupchek(insMap);
//			}
//
//			logger.debug("dupCnt %$%$%$%$%$%$ ??????: {}", dupCnt);
//
//		 if(dupCnt == 0){
//			 returnUsedPartsService.returnPartsUpdate(params,loginId);
//		 }

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(returnResult.get("dupCnt").toString());

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/scanSerialPop.do")
    public String smoIssueInPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    	model.addAttribute("url", params);
    	List<EgovMap> list = returnUsedPartsService.selectScanSerialInPop(params);

    	model.addAttribute("data", list);
        return "logistics/returnUsedParts/scanSerialPop";
    }

	@RequestMapping(value = "/selectScanSerialInList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectScanSerialInList(@RequestBody Map<String, Object> params, Model model) throws Exception {
    	ReturnMessage result = new ReturnMessage();

        List<EgovMap> list = returnUsedPartsService.selectScanSerialInPop(params);

        result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());

		return ResponseEntity.ok(result);
    }

	@RequestMapping(value = "/serialScanCommonPop.do")
	public String serialScanCommonPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("url", params);
		Map<String, Object> sParam = new HashMap<String, Object>();
		sParam.put("groupCode", "42");
		//model.addAttribute("uomList", commonService.selectCodeList(sParam));
		return "logistics/returnUsedParts/serialScanCommonPop";
	}

	@RequestMapping(value = "/deleteGridSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteGridSerial(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		returnUsedPartsService.deleteGridSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/deleteSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		returnUsedPartsService.deleteSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/saveReturnBarcode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveReturnBarcode(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		List<Object> list = returnUsedPartsService.saveReturnBarcode(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/saveReturnUsedSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveReturnUsedSerial(@RequestBody Map<String, Object>  params, SessionVO sessionVO) throws Exception {

		returnUsedPartsService.saveReturnUsedSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/returnPartsUpdateFailed.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> returnPartsUpdateFailed(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		 logger.debug("loginId@@@@@: {}", loginId);

		 Map<String, Object> returnResult = returnUsedPartsService.returnPartsUpdateFailed(params,loginId);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(returnResult.get("dupCnt").toString());

		return ResponseEntity.ok(message);
	}

}
