/**
 *
 */
package com.coway.trust.web.sales.mambership;

import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.mambership.MembershipRentalQuotationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 *
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/membershipRentalQut")
public class  MembershipRentalQuotationController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRentalQuotationController.class);

	@Resource(name = "membershipRentalQuotationService")
	private MembershipRentalQuotationService membershipRentalQuotationService;

	@Resource(name = "customerService")
	private CustomerService customerService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/membershipRentalQuotationList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  membershipRentalQuotationList.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		logger.debug("sessionVO ============>> " + sessionVO.getUserTypeId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		return "sales/membership/membershipRentalQuotationList";
	}




	@RequestMapping(value = "/quotationList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  quotationList(@RequestParam Map<String, Object> params,HttpServletRequest request
			, Model mode, SessionVO sessionVO)	throws Exception {


		String[] STUS_ID = request.getParameterValues("STUS_ID");

		params.put("STUS_ID", STUS_ID);
		params.put("userTypeId", sessionVO.getUserTypeId());


		logger.debug("in  quotationList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.quotationList(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/mViewQuotation.do")
	public String mViewQuotation(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mViewQuotation.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		model.addAttribute("QUOT_ID",params.get("QUOT_ID"));

		return "sales/membership/mRentalViewQuotationPop";
	}


	@RequestMapping(value = "/mNewQuotation.do")
	public String mNewQuotation(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mNewQuotation.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/mRentalNewQuotationPop";
	}



	@RequestMapping(value = "/newConfirm" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  newConfirm(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  newConfirm ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.newConfirm(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/mActiveQuoOrder" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  mActiveQuoOrder(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  mActiveQuoOrder ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.mActiveQuoOrder(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/getSrvMemCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getSrvMemCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  getSrvMemCode ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.getSrvMemCode(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/getPromotionCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getPromotionCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  getPromotionCode ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.getPromotionCode(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/selCheckExpService" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  selCheckExpService(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  selCheckExpService ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.selCheckExpService(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/mRPackageInfo" ,method = RequestMethod.GET)
	public ResponseEntity<Map> mRPackageInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  mRPackageInfo ");

		EgovMap packageInfo = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		packageInfo = membershipRentalQuotationService.mPackageInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("packageInfo", packageInfo);

		return ResponseEntity.ok(map);
	}




	@RequestMapping(value = "/mRFilterChargePop.do")
	public String mRFilterChargePop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mRFilterChargePop.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/mRentalFilterChargePop";
	}


	@RequestMapping(value = "/getFilterPromotionCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getFilterPromotionCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.getFilterPromotionCode(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/mNewQuotationSavePop.do")
	public String mNewQuotationSavePop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mNewQuotationSavePop.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		model.addAttribute("selValue",params.get("selValue"));
		return "sales/membership/mNewQuotationSavePop";
	}


	@RequestMapping(value = "/mNewQuotationSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> mNewQuotationSave(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		logger.debug("in  mNewQuotationSave ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			saveData		" + (Map)params.get("saveData"));
		logger.debug("			pram set end  ");

		params.put("qotatCrtUserId", sessionVO.getUserId());

		Map  pmap = (Map)params.get("saveData");
		pmap.put("isFilterChange",params.get("isFilterChange"));
		pmap.put("qotatCrtUserId",  sessionVO.getUserId() );


		int  rtnValue =  1;
		EgovMap   trnMmap =membershipRentalQuotationService.insertQuotationInfo(pmap);

		ReturnMessage message = new ReturnMessage();

		if(! trnMmap.get("qotatId").equals(""))  {
			message.setData(trnMmap);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);
	}




	@RequestMapping(value = "/getFilterPromotionAmt.do" ,method = RequestMethod.GET)
	public ResponseEntity< EgovMap>  getFilterPromotionAmt(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getFilterPromotionAmt ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		 EgovMap  list = membershipRentalQuotationService.getFilterPromotionAmt(params);

		return ResponseEntity.ok(list);
	}





	@RequestMapping(value = "/getFilterChargeList.do" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getFilterChargeList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getFilterChargeList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.getFilterChargeList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getFilterChargeListSum.do" ,method = RequestMethod.GET)
	public ResponseEntity<Double>  getFilterChargeListSum(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getFilterChargeListSum ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		double sum = membershipRentalQuotationService.getFilterChargeListSum(params);

		/*List<EgovMap>  list = (List<EgovMap>) params.get("p1");*/

		logger.debug("sum ==============>> " + sum);

		return ResponseEntity.ok(sum);
	}












	/*




	@RequestMapping(value = "/mNewQuotationSavePop.do")
	public String mNewQuotationSavePop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mNewQuotationSavePop.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/mNewQuotationSavePop";
	}






	@RequestMapping(value = "/newOListuotationList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  newOListuotationList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  newOListuotationList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.newOListuotationList(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/newGetExpDate")
	public ResponseEntity<Map> newGetExpDate(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  newGetExpDate ");

		EgovMap newGetExpDate = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		newGetExpDate = membershipRentalQuotationService.newGetExpDate(params);

		Map<String, Object> map = new HashMap();
		map.put("expDate", newGetExpDate);

		return ResponseEntity.ok(map);
	}




	@RequestMapping(value = "/mPackageInfo" ,method = RequestMethod.GET)
	public ResponseEntity<Map> mPackageInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  packageInfo ");

		EgovMap packageInfo = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		packageInfo = membershipRentalQuotationService.mPackageInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("packageInfo", packageInfo);

		return ResponseEntity.ok(map);
	}





	@RequestMapping(value = "/getFilterCharge" ,method = RequestMethod.GET)
	public ResponseEntity<Map> getFilterCharge(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		logger.debug("in  getFilterCharge ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		membershipRentalQuotationService.getFilterCharge(params);

		logger.debug("v_result : {}", params.get("p1"));

		Map<String, Object> map = new HashMap();
		map.put("outSuts", params.get("p1"));

		return ResponseEntity.ok(map);
	}







	@RequestMapping(value = "/getPromoPricePercent" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getPromoPricePercent(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getPromoPricePercent ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.getPromoPricePercent(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/getOrderCurrentBillMonth" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getOrderCurrentBillMonth(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getOrderCurrentBillMonth ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.getOrderCurrentBillMonth(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/mActiveQuoOrder" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  mActiveQuoOrder(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  mActiveQuoOrder ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipRentalQuotationService.mActiveQuoOrder(params);

		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/getOderOutsInfo" ,method = RequestMethod.GET)
	public ResponseEntity<Map> getOderOutsInfo(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		logger.debug("in  getFilterCharge ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		membershipRentalQuotationService.getOderOutsInfo(params);

		logger.debug("		====>			" + params.toString());

		//logger.debug("v_result : {}", params.get("p1"));

		Map<String, Object> map = new HashMap();
		//map.put("outsInfo", params.get("p1"));

		return ResponseEntity.ok(map);
	}



	@RequestMapping(value = "/mNewQuotationSave" ,method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> mNewQuotationSave(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  mNewQuotationSave ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");



		params.put("srvCreateBy", sessionVO.getUserId());
		params.put("srvUpdateAt", sessionVO.getUserId());

		membershipRentalQuotationService.insertQuotationInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("New contact successfully saved.");
		message.setData(params.get("SAL0093D_SEQ"));

		logger.debug("mNewQuotationSave SAL0093D_SEQ {}", params.get("SAL0093D_SEQ"));

		return ResponseEntity.ok(message);
	}




	*/


	@Autowired
	private MessageSourceAccessor messageAccessor;


	/******************************************************
	 * SEARCH MEMBERSHIP QUOTATION Pop-up
	 *****************************************************/
	/**
	 * Search Membership Quotation Pop-up 초기화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSrchMembershipQuotationPop.do")
	public String initSrchMembershipQuotationPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/membership/srchMembershipQuotationPop";
	}

	/**
	 * Search Membership Quotation Pop-up 리스트 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectSrchMembershipQuotationPop.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectSrchMembershipQuotationPop(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
			, @RequestBody Map<String, Object> params, ModelMap model) {
		// 조회.
		List<EgovMap> resultList = membershipRentalQuotationService.selectSrchMembershipQuotationPop(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}


	/**
	 * Membership Rental Quotation Covert To Sales Pop-up
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/mRentalQuotConvSalePop.do")
	public String mRentalQuotConvSalePop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("		==================>			" + params.toString());
		EgovMap basicinfo = null;

		params.put("qotatId", params.get("QUOT_ID"));

//		params.put("custCntcId", params.get("QUOT_ID"));
//		params.put("qotatId", params.get("QUOT_ID"));

		EgovMap packageInfo = membershipRentalQuotationService.cnvrToSalesPackageInfo(params);
		params.put("ordId", packageInfo.get("qotatOrdId"));
		params.put("exprDt", SalesConstants.DEFAULT_DATE);
		EgovMap orderInfo = membershipRentalQuotationService.cnvrToSalesOrderInfo(params);
		params.put("custCntcId", orderInfo.get("ordCntcId"));
		EgovMap orderInfo2nd = membershipRentalQuotationService.cnvrToSalesOrderInfo2nd(params);
		EgovMap addrInfo = membershipRentalQuotationService.cnvrToSalesAddrInfo(params);
		EgovMap cntcInfo = membershipRentalQuotationService.cnvrToSalesCntcInfo(params);

		params.put("svcCntrctId", 0);
		EgovMap thrdPartyInfo = membershipRentalQuotationService.cnvrToSalesThrdParty(params);


		if(thrdPartyInfo != null){
			params.put("custId", thrdPartyInfo.get("custId"));
			basicinfo = customerService.selectCustomerViewBasicInfo(params);
			model.addAttribute("custId",thrdPartyInfo.get("custId"));
		}else{
			params.put("custId", orderInfo.get("custId"));
			model.addAttribute("custId",orderInfo.get("custId"));
			basicinfo = customerService.selectCustomerViewBasicInfo(params);;
		}
		model.addAttribute("packageInfo",packageInfo);
		model.addAttribute("orderInfo",orderInfo);
		model.addAttribute("orderInfo2nd",orderInfo2nd);
		model.addAttribute("addrInfo",addrInfo);
		model.addAttribute("cntcInfo",cntcInfo);
		model.addAttribute("thrdPartyInfo",thrdPartyInfo);
		model.addAttribute("basicinfo",basicinfo);
		model.addAttribute("qotatId",params.get("QUOT_ID"));

		return "sales/membership/mRentalQuotConvSalePop";
	}

	@RequestMapping(value = "/cnvrToSalesfilterChgJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> cnvrToSalesfilterChgJsonList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 조회.
		List<EgovMap> filterList = membershipRentalQuotationService.cnvrToSalesfilterChgList(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(filterList);
	}

	@RequestMapping(value = "/saveCnvrToSale.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveCnvrToSale(@RequestParam Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		logger.debug("in  saveCnvrToSale ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
//		logger.debug("			saveData		" + (Map)params.get("saveData"));
//		logger.debug("			pram set end  ");

		params.put("userId", sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		params.put("branchId", sessionVO.getUserBranchId() != 0 ? sessionVO.getUserBranchId() : 0);

		EgovMap   trnMmap =membershipRentalQuotationService.insertCnvrToSale(params);

		ReturnMessage message = new ReturnMessage();

//		if(! trnMmap.get("qotatId").equals(""))  {
			message.setData(trnMmap);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		}else{
//			message.setCode(AppConstants.FAIL);
//			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	//	}
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateStus" ,method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updateStus(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  updateStus ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		params.put("userId", sessionVO.getUserId());

		membershipRentalQuotationService.updateStus(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData("");

		return ResponseEntity.ok(message);
	}


}
