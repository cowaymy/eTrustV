package com.coway.trust.web.services.bs;

import java.text.ParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberListController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs")
public class HsManualController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "hsManualService")
	private HsManualService hsManualService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;
	

	@Autowired
	private MessageSourceAccessor messageAccessor;



    	@RequestMapping(value = "/initHsManualList.do")
    	public String initBsManagementList(@RequestParam Map<String, Object> params, ModelMap model) {

    		List<EgovMap> branchList = hsManualService.selectBranchList(params);
    		model.addAttribute("branchList", branchList);


		return "services/bs/hsManual";
    	}




		@RequestMapping(value = "/selectHSConfigListPop.do")
		public String selectHSConfigListPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

			model.addAttribute("brnchCdList",  params.get("BrnchId"));
			model.addAttribute("ordCdList",  params.get("CheckedItems"));
			model.addAttribute("ManuaMyBSMonth",  params.get("ManuaMyBSMonth"));
			model.addAttribute("SalesOrderNo",  params.get("SalesOrderNo"));

			return "services/bs/hSConfigPop";
		}




		@RequestMapping(value = "/selecthSCodyChangePop.do")
		public String selecthSCodyChangePop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

			model.addAttribute("brnchCdList",  params.get("BrnchId"));
			model.addAttribute("ordCdList",  params.get("CheckedItems"));
			model.addAttribute("ManuaMyBSMonth",  params.get("ManuaMyBSMonth"));

			return "services/bs/hSCodyChangePop";
		}



		@RequestMapping(value = "/assignCDChangeListSave.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> assignCDChangeListSave(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

			logger.debug("in  assignCDChangeListSave ");
			logger.debug("			pram set  log");
			logger.debug("					" + params.toString());
			logger.debug("			pram set end  ");

			params.put("updator", sessionVO.getUserId());
			List<EgovMap>  update 	= (List<EgovMap>)  params.get("update");
			logger.debug("HSResultM ===>"+update.toString());

			String   rtnValue = hsManualService.updateAssignCody(params);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setData(99);
			message.setMessage(rtnValue);


			return ResponseEntity.ok(message);

		}




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





	/**
	 * Services - HS  - HSConfigSettingt List 메인 화면
	 *
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initHSConfigSettingList.do")
	public String initHSConfigSettingList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsConfigSetting";
	}



	@RequestMapping(value = "/selectHsBasicList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsBasicList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {

		params.put("user_id", sessionVO.getUserId());

        // 조회.
		List<EgovMap> hsBasicList = hsManualService.selectHsConfigList(params);

		//brnch 임시 셋팅
		for (int i=0 ; i < hsBasicList.size() ; i++){
			EgovMap record = (EgovMap) hsBasicList.get(i);//EgovMap으로 형변환하여 담는다.
		}

		return ResponseEntity.ok(hsBasicList);
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
	//HS manual
	@RequestMapping(value = "/getCdDeptList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCdDeptList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsManualService.getCdDeptList(params);

		return ResponseEntity.ok(resultList);
	}

    /* BY KV - Change to textBox -  txtcodyCode and below code no more used.*/
	/*@RequestMapping(value = "/getCdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCdList(@RequestParam Map<String, Object>params) {
        // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsManualService.getCdList(params);

		return ResponseEntity.ok(resultList);
	}*/




	@RequestMapping(value = "/hsOrderSave.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertHsResult(@RequestBody Map<String, Object> params,SessionVO sessionVO) throws ParseException {
		Boolean success = false;
		String msg = "";


		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);


		Map<String, Object> resultValue = new HashMap<String, Object>();
		ReturnMessage message = new ReturnMessage();
		resultValue = hsManualService.insertHsResult(formMap, updList);



		message.setMessage("Complete to Add a HS Order.  " + resultValue.get("docNo"));


		return ResponseEntity.ok(message);

	}



	@RequestMapping(value = "/selectHsInitDetailPop.do")
	public String selectHsInitDetailPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		params.put("schdulId", params.get("schdulId"));
		params.put("salesOrderId", params.get("salesOrdId"));

		EgovMap  hsDefaultInfo = hsManualService.selectHsInitDetailPop(params);
		List<EgovMap>  cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);
//		List<EgovMap>  cmbServiceMemList = hsManualService.cmbServiceMemList(params);
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params,sessionVO);//
		List<EgovMap>  failReasonList = hsManualService.failReasonList(params);
//		List<EgovMap>  serMemList = hsManualService.serMemList(params);


		logger.debug(" params : " , params);
		logger.debug("hsDefaultInfo : {}", hsDefaultInfo);

		model.addAttribute("hsDefaultInfo", hsDefaultInfo);
		model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
//		model.addAttribute("cmbServiceMemList", cmbServiceMemList);
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("failReasonList", failReasonList);
//		model.addAttribute("serMemList", serMemList);



		return "services/bs/hsDetailPop";

	}





	@RequestMapping(value = "/hsBasicInfoPop.do")
	public String selecthsBasicInfoPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		EgovMap basicinfo = null;
		EgovMap addresinfo = null;
		EgovMap contactinfo = null;
		EgovMap orderDetail = null;

		params.put("salesOrderId", params.get("salesOrdId"));
		logger.debug("===========================================>");  
		logger.debug("params : {}", params);  
		logger.debug("===========================================>");  

		basicinfo = hsManualService.selectHsViewBasicInfo(params);
		orderDetail = orderDetailService.selectOrderBasicInfo(params,sessionVO);

		List<EgovMap>  cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);
		List<EgovMap>  failReasonList = hsManualService.failReasonList(params);
		//List<EgovMap>  serMemList = hsManualService.serMemList(params);



		model.addAttribute("basicinfo", basicinfo);
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
		model.addAttribute("failReasonList", failReasonList);
		model.addAttribute("MOD", params.get("MOD"));
		//model.addAttribute("serMemList", serMemList);

		return "services/bs/hsEditPop";


	}



	@RequestMapping(value = "/selectHsViewfilterPop.do")
	public ResponseEntity<List<EgovMap>> selectHsViewfilterPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		List<EgovMap> hsViewfilterInfo = null;

		hsViewfilterInfo = hsManualService.selectHsViewfilterInfo(params);
		//model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

		return ResponseEntity.ok(hsViewfilterInfo);
	}



	@RequestMapping(value = "/selectHistoryHSResult.do")
	public ResponseEntity<List<EgovMap>> selectHistoryHSResult(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		List<EgovMap> historyHSResult = null;

		historyHSResult = hsManualService.selectHistoryHSResult(params);

		return ResponseEntity.ok(historyHSResult);
	}



	@RequestMapping(value = "/selectFilterTransaction.do")
	public ResponseEntity<List<EgovMap>> selectFilterTransaction(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		List<EgovMap> filterTransaction = null;

		filterTransaction = hsManualService.selectFilterTransaction(params);

		return ResponseEntity.ok(filterTransaction);
	}







	@RequestMapping(value = "/SelectHsFilterList.do")
	public ResponseEntity<List<EgovMap>> SelectHsFilterList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) throws Exception {

		//params.put("salesOrdId", params.get("salesOrdId"));

		List<EgovMap> hsFilterList = hsManualService.selectHsFilterList(params);
//		model.addAttribute("hsFilterList", hsFilterList);

		return ResponseEntity.ok(hsFilterList);

	}






	/**
	 * Search rule book management list
	 *
	 * @param params
	 * @param request
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 */
	@RequestMapping(value = "/addIHsResult.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> addIHsResult(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		logger.debug("params : {}", params);

		boolean success = false;
		Map<String, Object> resultValue = new HashMap<String, Object>();

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		resultValue = hsManualService.addIHsResult(formMap, updList, sessionVO);
		
		  
		if( null !=resultValue){
			
			HashMap   spMap =(HashMap)resultValue.get("spMap");
			
			logger.debug("spMap :========>"+ spMap.toString());   
			
			if(! "000".equals(spMap.get("P_RESULT_MSG"))){
				
				resultValue.put("logerr","Y");
				message.setMessage("Logistics call Error." );
			}else{
				
				message.setMessage("Complete to Add a HS Order : " + resultValue.get("resultId") );
			}
			
			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
		}
		
		

		return ResponseEntity.ok(message);
	}



//
	/**
	 * Search rule book management list
	 *
	 * @param params
	 * @param request
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 */
	
	@RequestMapping(value = "/UpdateHsResult2.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> UpdateHsResult2(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		logger.debug("params : {}", params);

		boolean success = false;
		Map<String, Object> resultValue = new HashMap<String, Object>();

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		resultValue = hsManualService.UpdateHsResult2(formMap, updList, sessionVO);

		message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno") );

		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/UpdateHsResult.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> UpdateHsResult(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		logger.debug("params : {}", params);

		boolean success = false;
		Map<String, Object> resultValue = new HashMap<String, Object>();

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		resultValue = hsManualService.UpdateHsResult(formMap, updList, sessionVO);

		message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno") );

		return ResponseEntity.ok(message);
	}





	@RequestMapping(value = "/hsConfigBasicPop.do	" )
	public String hsConfigBasicPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("params : {}", params.toString());
		params.put("orderNo", params.get("salesOrdId"));

		//List<EgovMap>  cmbServiceMemList = hsManualService.cmbServiceMemList(params);
		EgovMap configBasicInfo = hsManualService.selectConfigBasicInfo(params);
		//EgovMap configBasicInfo = hsManualService.selectConfigBasicInfo(params);
	//	EgovMap serMember = hsManualService.se ;
//		EgovMap as_ord_basicInfo = hsManualService.selectOrderBasicInfo(params);
//		EgovMap asentryInfo =null;

//		model.put("cmbServiceMemList", cmbServiceMemList);
		model.put("configBasicInfo", configBasicInfo);
		model.put("SALEORD_ID",(String) params.get("salesOrdId"));

//		model.put("as_ord_basicInfo", as_ord_basicInfo);
//		model.put("AS_NO", (String)params.get("AS_NO"));
		model.put("BRNCH_ID",(String) params.get("brnchId"));
		
		//
		

		return "services/bs/hsConfigBasicPop";
	}


	/**
	 * Services -
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getHSConfigBasicInfo.do")
	public String getHSConfigBasicInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("params : {}", params.toString());
		params.put("orderNo", params.get("salesOrdId"));

//		List<EgovMap>  cmbServiceMemList = hsManualService.cmbServiceMemList(params);
//		model.put("cmbServiceMemList", cmbServiceMemList);
//		List<EgovMap>  serMemList = hsManualService.serMemList(params);
//		model.addAttribute("serMemList", serMemList);

		return "services/bs/hsConfigBasicPop";
	}




	@RequestMapping(value = "/getHSCody.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getHSCody(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params : {}", params);
		EgovMap serMember = null ;
		 serMember = hsManualService.serMember(params);


		return ResponseEntity.ok(serMember);
	}




	@RequestMapping(value = "/hSFilterSettingPop.do" )
	public String hSFilterSettingPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("params : {}", params.toString());
		params.put("orderNo", params.get("salesOrdId"));

		EgovMap hSOrderView = hsManualService.selectHSOrderView(params);
		model.put("hSOrderView", hSOrderView);

		return "services/bs/hSFilterSettingPop";
	}


		@RequestMapping(value = "/getActivefilterInfo.do" )
		public ResponseEntity<List<EgovMap>> getActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

			logger.debug("params : {}", params.toString());
			params.put("orderNo", params.get("salesOrdId"));

			List<EgovMap>  orderActiveFilter = hsManualService.selectOrderActiveFilter(params);

			model.put("orderActiveFilter", orderActiveFilter);
	
			return ResponseEntity.ok(orderActiveFilter);
		}


		@RequestMapping(value = "/getInActivefilterInfo.do" )
		public ResponseEntity<List<EgovMap>> getInActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

			logger.debug("params : {}", params.toString());
			params.put("orderNo", params.get("salesOrdId"));

			List<EgovMap>  orderInactiveFilter = hsManualService.selectOrderInactiveFilter(params);

			model.put("orderInactiveFilter", orderInactiveFilter);

			return ResponseEntity.ok(orderInactiveFilter);
		}



		@RequestMapping(value = "/hSAddFilterSetPop.do" )
		public String hSAddFilterSetInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

			logger.debug("params : {}", params.toString());
			params.put("orderNo", params.get("salesOrdId"));

			List<EgovMap>  hSAddFilterSetInfo = hsManualService.selectHSAddFilterSetInfo(params);
			model.put("_salesOrdId",(String) params.get("salesOrdId"));   
			model.put("_stkId",(String) params.get("stkId"));
			model.put("hSAddFilterSetInfo", hSAddFilterSetInfo);

			return "services/bs/hsFilterAddPop";
		}
		
		

		@RequestMapping(value = "/addSrvFilterID.do" )
		public ResponseEntity<List<EgovMap>>  addSrvFilterIdCnt(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

			List<EgovMap> addSrvFilterIdCnt = hsManualService.addSrvFilterIdCnt(params);
			
			return ResponseEntity.ok(addSrvFilterIdCnt);
		}			

		
		
		
		@RequestMapping(value = "/doSaveFilterInfo.do",method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> saveHsFilterInfoAdd(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
			ReturnMessage message = new ReturnMessage();
			params.put("updator", sessionVO.getUserId());
			
			logger.debug("params : {}", params);
//			List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
			
			int resultValue = hsManualService.saveHsFilterInfoAdd(params);
			
			if(resultValue>0){
				message.setCode(AppConstants.SUCCESS);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			}else{
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
			return ResponseEntity.ok(message);
		}		
		

		

		@RequestMapping(value = "/doSaveDeactivateFilter.do",method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> doSaveDeactivateFilter(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
			ReturnMessage message = new ReturnMessage();
			params.put("updator", sessionVO.getUserId());
			params.put("srvFilterStusId", 8);
			
			logger.debug("params : {}", params);
			
			int resultValue = hsManualService.saveDeactivateFilter(params);
			
			if(resultValue>0){
				message.setCode(AppConstants.SUCCESS);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			}else{
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
			return ResponseEntity.ok(message);
		}
		
		
		
		
	/**
	 *
	 *
	 * @param params
	 * @param request
	 * @return
	 * @throws ParseException
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveHsConfigBasic.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHsConfigBasic(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();

		logger.debug("params : {}", params);
        String srvCodyId = "";
        LinkedHashMap  hsResultM = (LinkedHashMap)params.get("hsResultM");
        srvCodyId =  hsManualService.getSrvCodyIdbyMemcode(hsResultM);
        hsResultM.put("cmbServiceMem", srvCodyId);
        hsResultM.put("hscodyId", srvCodyId);
        hsManualService.updateSrvCodyId(hsResultM);
		logger.debug("params111111111 : {}", params);
//		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		
		logger.debug("hsResultM ===>"+hsResultM.toString());

		int resultValue = hsManualService.updateHsConfigBasic(params, sessionVO);


		if(resultValue >0 ){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/hsCountForecastListingPop.do")
	public String hsCountForecastListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsCountForecastListingPop";
	}

	@RequestMapping(value = "/hsReportGroupPop.do")
	public String hsReportGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsReportGroupPop";
	}

	@RequestMapping(value = "/hsReportSinglePop.do")
	public String hsReportSinglePop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsReportSinglePop";
	}

	@RequestMapping(value = "/selectBranch_id", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranch_id( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> branchList = hsManualService.selectBranch_id(params);
		//model.addAttribute("branchList", branchList);
		logger.debug("branchList {}", branchList);
		return ResponseEntity.ok(branchList);
	}

	@RequestMapping(value = "/selectCTMByDSC_id", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTMByDSC_id( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> branchList = hsManualService.selectCTMByDSC_id(params);
		//model.addAttribute("branchList", branchList);
		logger.debug("branchList {}", branchList);
		return ResponseEntity.ok(branchList);
	}
	
	@RequestMapping(value = "/checkMemCode")
	public  ResponseEntity<ReturnMessage> checkMemberCode(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("params : {}", params.toString());
	
		
		EgovMap checkMemCode = hsManualService.selectCheckMemCode(params);
		
		
		ReturnMessage message = new ReturnMessage();
		if(checkMemCode != null && checkMemCode.size() != 0){
			message.setMessage("success");
		}
		else {
			message.setMessage("fail" );
		}
		return  ResponseEntity.ok(message);
	}

	
	
	
	
	
	
	@RequestMapping(value = "/hSFilterUseHistoryPop.do")
	public String hSFilterUseHistoryPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		model.put("orderId",(String) params.get("orderId"));
		model.put("stkId",(String) params.get("stkId"));
		model.put("srvFilterStkId",(String) params.get("srvFilterStkId"));
		
		// 호출될 화면
		return "services/bs/hSFilterUseHistoryPop";
	}	
		
	
	@RequestMapping(value = "/hSFilterUseHistory.do")
	public ResponseEntity<List<EgovMap>> gethSFilterUseHistory(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

			logger.debug("params : {}", params.toString());

			//List<EgovMap>  useHistoryInfo = hsManualService.selecthSFilterUseHistorycall(params);
			
			hsManualService.selecthSFilterUseHistorycall(params);
			
			List<EgovMap> list = (List<EgovMap>)params.get("cv_1");
			
			logger.debug("============hSFilterUseHistory useHistoryInfo Start =======================================================");
			logger.debug("==========useHistoryInfo {} " ,list ); 
			logger.debug("============hSFilterUseHistory useHistoryInfo End =======================================================");
			

			model.put("list", list);
	
			return ResponseEntity.ok(list);
		}	
	
	
	@RequestMapping(value = "/doSaveFilterUpdate.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> doSaveFilterUpdate(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		params.put("updator", sessionVO.getUserId());
		
		logger.debug("params : {}", params);
		
		params.put("srvFilterStusId", "1");
		
		int resultValue = hsManualService.saveDeactivateFilter(params);
		
		if(resultValue>0){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);
	}
	
}
	


