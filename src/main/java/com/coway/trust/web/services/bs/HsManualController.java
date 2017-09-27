package com.coway.trust.web.services.bs;

import java.text.ParseException;
import java.util.HashMap;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberListController;
import com.google.gson.Gson;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller 
@RequestMapping(value = "/bs")
public class HsManualController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);
	@Resource(name = "hsManualService")
	private HsManualService hsManualService;
	
	
	@RequestMapping(value = "/initHsManualList.do")
	public String initBsManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> branchList = hsManualService.selectBranchList(params);
		model.addAttribute("branchList", branchList);
		
		
		return "services/bs/hsManual";
	}
	
	
	
	
		@RequestMapping(value = "/selectHSConfigListPop.do")
		public String selectHSConfigListPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
//			params.put("user_id", sessionVO.getUserId());
//			
//			logger.debug("params : {}", params);
//			logger.debug("params : {}", params.get("SaleOrdList"));
//			
//			
//			
//
//			if(null != params.get("SaleOrdList")){
//				
//    			String olist = (String)params.get("SaleOrdList");
//    			
//    			String[] spl = olist.split(",");
//    			
//    			params.put("saleOrdListSp", spl);
//			}
//			
//			//brnch to CodyList
//			List<EgovMap> resultList = hsManualService.getCdList_1(params);

			model.addAttribute("brnchCdList",  params.get("BrnchId"));	
			model.addAttribute("ordCdList",  params.get("CheckedItems"));
//			
//			List<EgovMap> resultList1 = hsManualService.selectHsManualListPop(params);

//			
//			//model.addAttribute("ordCdList",  new Gson().toJson(params.get("SaleOrdList")));
			
			return "services/bs/hSConfigPop";
		}
		
		
//		@RequestMapping(value = "/selectBrnchCdList.do")
//		public String selectBrnchCdList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
//			
//			//brnch to CodyList
//			List<EgovMap> resultList = hsManualService.getCdList_1(params);
//			model.addAttribute("brnchCdList", resultList);
//			
//			return "services/bs/hSConfigPop";
//		}		
		
		
		

		@RequestMapping(value = "/selectPopUpCdList.do")
		public ResponseEntity<List<EgovMap>> selectPopUpCdList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

			Map parameterMap = request.getParameterMap();
			String[] nameParam = (String[])parameterMap.get("name");
			
			logger.debug(" selectPopUpList in  ");
			logger.debug(" 			: "+params.toString());
			logger.debug(" selectPopUpList in  ");
			
			if(null != params.get("SaleOrdList")){
				
    			String olist = (String)params.get("SaleOrdList");
    			
    			String[] spl = olist.split(",");
    			
    			params.put("saleOrdListSp", spl);
			}
			
			//brnch to CodyList
			List<EgovMap> resultList = hsManualService.getCdList_1(params);
			//model.addAttribute("brnchCdList1", resultList);	

			List<EgovMap> resultList1 = hsManualService.selectHsManualListPop(params);
			//model.addAttribute("ordCdList1", resultList1);
			
			return ResponseEntity.ok(resultList);
		}
		
		
		
		@RequestMapping(value = "/selectPopUpCustList.do")
		public ResponseEntity<List<EgovMap>> selectPopUpCustList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

			Map parameterMap = request.getParameterMap();
			String[] nameParam = (String[])parameterMap.get("name");
			
			logger.debug(" selectPopUpList in  ");
			logger.debug(" 			: "+params.toString());
			logger.debug(" selectPopUpList in  ");
			
			if(null != params.get("SaleOrdList")){
				
    			String olist = (String)params.get("SaleOrdList");
    			
    			String[] spl = olist.split(",");
    			
    			params.put("saleOrdListSp", spl);
			}

			List<EgovMap> resultList1 = hsManualService.selectHsManualListPop(params);
			//model.addAttribute("ordCdList1", resultList1);
			
			return ResponseEntity.ok(resultList1);
		}

		
//		@RequestMapping(value = "/selectBrnchCdList.do")
//		public String selectBrnchCdList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
//			
//			//brnch to CodyList
//			List<EgovMap> resultList = hsManualService.getCdList_1(params);
//			model.addAttribute("brnchCdList", resultList);
//			
//			return "services/bs/hSConfigPop";
//		}	
		
		
		
		
	
	@RequestMapping(value = "/selectHsManualList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsManualList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		
		params.put("user_id", sessionVO.getUserId());
		
        // 조회.
		List<EgovMap> bsManagementList = hsManualService.selectHsManualList(params);        
		
		//brnch 임시 셋팅
		for (int i=0 ; i < bsManagementList.size() ; i++){
			
			EgovMap record = (EgovMap) bsManagementList.get(i);//EgovMap으로 형변환하여 담는다.
			
//			("brnchId", sessionVO.getUserBranchId());
		}

		
		return ResponseEntity.ok(bsManagementList);
	}
	
	
	
	
	@RequestMapping(value = "/selectHsAssiinlList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsAssiinlList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		
		params.put("user_id", sessionVO.getUserId());
		
        // 조회.
		List<EgovMap> hsAssiintList = hsManualService.selectHsAssiinlList(params);        
		
		return ResponseEntity.ok(hsAssiintList);
	}
	
	
	@RequestMapping(value = "/getCdUpMemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCdUpMemList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsManualService.getCdUpMemList(params);        

		return ResponseEntity.ok(resultList);
	}
	
	
	
	@RequestMapping(value = "/getCdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCdList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsManualService.getCdList(params);        

		return ResponseEntity.ok(resultList);
	}
	
	
	
	
	@RequestMapping(value = "/hsOrderSave.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertHsResult(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		Boolean success = false;
		String msg = "";
		
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD); 
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);


		ReturnMessage message = new ReturnMessage();
		success = hsManualService.insertHsResult(formMap, updList);
		
		return ResponseEntity.ok(message);
	}
	
	
	
	
}
