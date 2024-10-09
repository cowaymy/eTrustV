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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.mambership.MembershipQuotationService;
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 *
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipQuotationController {

	private static Logger logger = LoggerFactory.getLogger(MembershipQuotationController.class);

	@Resource(name = "membershipQuotationService")
	private MembershipQuotationService membershipQuotationService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/membershipQuotationList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  membershipQuotation.do ");

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


		return "sales/membership/membershipQuotationList";
	}

	@RequestMapping(value = "/mViewQuotation.do")
	public String mViewQuotation(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mViewQuotation.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


	    model.addAttribute("QUOT_ID",params.get("QUOT_ID"));
		model.addAttribute("ORD_ID",params.get("ORD_ID"));
		model.addAttribute("CNT_ID",params.get("CNT_ID"));
		model.addAttribute("MBRSH_ID",params.get("MBRSH_ID"));

		return "sales/membership/mViewQuotationPop";
	}



	@RequestMapping(value = "/mNewQuotation.do")
	public String mNewQuotation(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mNewQuotation.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		int sstValue = commonService.getSstTaxRate();
		model.put("sstValue", sstValue);
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "sales/membership/mNewQuotationPop";
	}

	@RequestMapping(value = "/mQuotationRawData.do")
	public String mQuotationRawData(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mNewQuotation.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		return "sales/membership/mQuotationRawDataPop";
	}

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

		List<EgovMap>  list = membershipQuotationService.newOListuotationList(params);

		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/quotationList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  quotationList(@RequestParam Map<String, Object> params,HttpServletRequest request,
			Model mode, SessionVO sessionVO)	throws Exception {


		String[] VALID_STUS_ID = request.getParameterValues("VALID_STUS_ID");

		params.put("VALID_STUS_ID", VALID_STUS_ID);

		params.put("userTypeId", sessionVO.getUserTypeId());

		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		List<EgovMap>  list = membershipQuotationService.quotationList(params);

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

		newGetExpDate = membershipQuotationService.newGetExpDate(params);

		Map<String, Object> map = new HashMap();
		map.put("expDate", newGetExpDate);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/getSrvMemCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getSrvMemCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  getSrvMemCode ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.getSrvMemCode(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/mPackageInfo" ,method = RequestMethod.GET)
	public ResponseEntity<Map> mPackageInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  packageInfo ");

		EgovMap packageInfo = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		packageInfo = membershipQuotationService.mPackageInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("packageInfo", packageInfo);

		return ResponseEntity.ok(map);
	}



	@RequestMapping(value = "/getPromotionCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getPromotionCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  getPromotionCode ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.getPromotionCode(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/getFilterCharge" ,method = RequestMethod.GET)
	public ResponseEntity<Map> getFilterCharge(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		logger.debug("in  getFilterCharge ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


	 	membershipQuotationService.getFilterCharge(params);

		logger.debug("v_result : {}", params.get("p1"));

		Map<String, Object> map = new HashMap();
		map.put("outSuts", params.get("p1"));

		return ResponseEntity.ok(map);
	}



	@RequestMapping(value = "/mFilterChargePop.do")
	public String mFilterChargePop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mNewQuotation.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		return "sales/membership/mFilterChargePop";
	}



	@RequestMapping(value = "/getFilterPromotionCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getFilterPromotionCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {



		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.getFilterPromotionCode(params);

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/getPromoPricePercent" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getPromoPricePercent(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getPromoPricePercent ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.getPromoPricePercent(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/getOrderCurrentBillMonth" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getOrderCurrentBillMonth(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getOrderCurrentBillMonth ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.getOrderCurrentBillMonth(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/mSubscriptionEligbility" ,method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>>  mSubscriptionEligbility(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  mSubscriptionEligbility ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		Map<String, Object>  list = membershipQuotationService.mSubscriptionEligbility(params);

		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/mActiveQuoOrder" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  mActiveQuoOrder(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  mActiveQuoOrder ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.mActiveQuoOrder(params);

		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/getOderOutsInfo" ,method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOderOutsInfo(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		logger.debug("in  getFilterCharge ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		EgovMap  map =  new EgovMap();
		map =membershipQuotationService.getOderOutsInfo(params);

		if(null !=map ){
			logger.debug("		====>			" + map.toString());
		}



		return ResponseEntity.ok(map);
	}
	//webster lee 17072020 : added a validation for outright membership ledger
	@RequestMapping(value = "/getOutrightMemLedge" ,method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOutrightMemLedge(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		logger.debug("in  getOutrightMemLedge ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		EgovMap  map =  membershipQuotationService.getOutrightMemLedge(params);
		if(null !=map ){
			logger.debug("		====>			" + map.toString());
		}
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

		String docNo = membershipQuotationService.insertQuotationInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage((String)params.get("SAL0093D_NO"));
		message.setData(docNo);


		logger.debug("mNewQuotationSave SAL0093D_SEQ {}", params.get("SAL0093D_SEQ"));

		return ResponseEntity.ok(message);
	}

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
		List<EgovMap> resultList = membershipQuotationService.selectSrchMembershipQuotationPop(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}



	@RequestMapping(value = "/getFilterPromotionAmt.do" ,method = RequestMethod.GET)
	public ResponseEntity< EgovMap>  getFilterPromotionAmt(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getFilterPromotionAmt ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		 EgovMap  list = membershipQuotationService.getFilterPromotionAmt(params);

		return ResponseEntity.ok(list);
	}





	@RequestMapping(value = "/getFilterChargeList.do" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getFilterChargeList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getFilterChargeList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.getFilterChargeList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getFilterChargeListSum.do" ,method = RequestMethod.GET)
	public ResponseEntity<Double> getFilterChargeListSum(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  getFilterChargeListSum ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		double sum = membershipQuotationService.getFilterChargeListSum(params);

		/*List<EgovMap>  list = (List<EgovMap>) params.get("p1");*/

		logger.debug("sum ==============>> " + sum);

		return ResponseEntity.ok(sum);
	}


	@RequestMapping(value = "/updateStus" ,method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updateStus(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  updateStus ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		params.put("userId", sessionVO.getUserId());

		membershipQuotationService.updateStus(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage((String)params.get("SAL0093D_NO"));
		message.setData(params.get("SAL0093D_SEQ"));


		logger.debug("mNewQuotationSave SAL0093D_SEQ {}", params.get("SAL0093D_SEQ"));

		return ResponseEntity.ok(message);
	}


  @RequestMapping(value = "/getMaxPeriodEarlyBirdPromo")
  public ResponseEntity<Map> getMaxPeriodEarlyBirdPromo(@RequestParam Map<String, Object> params, Model model)
      throws Exception {

    EgovMap getMaxPeriodEarlyBirdPromo = null;

    logger.debug("getMaxPeriodEarlyBirdPromo prams: " + params.toString());

    getMaxPeriodEarlyBirdPromo = membershipQuotationService.getMaxPeriodEarlyBirdPromo(params);

    logger.debug("getMaxPeriodEarlyBirdPromo: " + getMaxPeriodEarlyBirdPromo);

    Map<String, Object> map = new HashMap();
    map.put("getMaxPeriodEarlyBirdPromo", getMaxPeriodEarlyBirdPromo);

    return ResponseEntity.ok(map);
  }


  @RequestMapping(value = "/mEligibleEVoucher" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  mEligibleEVoucher(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		logger.debug("in  mEligibleEVoucher ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap>  list = membershipQuotationService.mEligibleEVoucher(params);

		return ResponseEntity.ok(list);
	}

}
