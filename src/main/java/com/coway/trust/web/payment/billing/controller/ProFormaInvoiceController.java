package com.coway.trust.web.payment.billing.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.ProFormaInvoiceService;
import com.coway.trust.biz.payment.invoice.service.InvoicePOService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/payment")
public class ProFormaInvoiceController {

	private static final Logger logger = LoggerFactory.getLogger(ProFormaInvoiceController.class);

	@Resource(name = "proFormaInvoiceService")
	private ProFormaInvoiceService proFormaInvoiceService;

	@Resource(name = "orderListService")
	private OrderListService orderListService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "invoicePOService")
	private InvoicePOService invoicePOService;

	@RequestMapping(value = "/initProFormaInvoice.do")
	public String initProFormaInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/proFormaInvoiceList";
	}

	@RequestMapping(value = "/newProFormaPop.do")
	public String newProFormaPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/newProFormaPop";
	}

	@RequestMapping(value = "/searchProFormaInvoiceList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  searchProFormaInvoiceList(@RequestParam Map<String, Object> params,HttpServletRequest request,
			Model mode, SessionVO sessionVO)	throws Exception {

		String[] arrBrnchCode = request.getParameterValues("brnchCode");
		String[] arrStatus = request.getParameterValues("status");

		params.put("arrBrnchCode", arrStatus);
		params.put("arrBrnchCode", arrBrnchCode);

		params.put("userTypeId", sessionVO.getUserTypeId());

		String[] arrayCustId =null;
		if( ! StringUtils.isEmpty(params.get("custName")) ||! StringUtils.isEmpty(params.get("crtUserId"))){
			arrayCustId =this.getExtCustIdList(params);
			params.put("arrayCustId", arrayCustId);
		}

		logger.debug("////////ProFormaList///////");
		logger.debug(params.toString());
		logger.debug("////////ProFormaList///////");

		List<EgovMap>  list = proFormaInvoiceService.searchProFormaInvoiceList(params);

		return ResponseEntity.ok(list);
	}

	public  String[]  getExtCustIdList( Map<String, Object> params ) throws Exception  {

	   	String[]  arrayCustId =null;

		logger.debug("getExtCustIdList in ......");
		logger.debug("params {}",params);

	   //get Cust_ID for sal0029d
		List<EgovMap> custIdList = null;
		custIdList = orderListService.getCustIdOfOrderList(params);

		if( null != custIdList  && custIdList.size() >0){
			//init
			arrayCustId = new String[custIdList.size()];

			for (int i=0;i<custIdList.size(); i++){
				EgovMap am=(EgovMap)custIdList.get(i);
				arrayCustId[i]=  ((BigDecimal) am.get("custId")).toString();
			}
		}

		logger.debug("custIdList {}" ,custIdList);
		logger.debug("getExtCustIdList  end ......");
		return arrayCustId;
   }

	@RequestMapping(value = "/ProFormaEditViewPop.do")
	  public String ProFormaEditViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

		logger.debug("===========================/ProFormaEditViewPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/ProFormaEditViewPop.do===============================");

	    model.put("ORD_ID", (String) params.get("salesOrdId"));
	    model.put("ORD_NO", (String) params.get("salesOrdNo"));
	    model.put("refNo", (String) params.get("refNo"));
	    model.put("proFormaId", (String) params.get("proFormaId"));
	    model.put("viewType", (String) params.get("viewType")); //view or edit

	    model.put("USER_ID", sessionVO.getMemId());
	    model.put("USER_NAME", sessionVO.getUserName());

	    model.put("BRANCH_NAME", sessionVO.getBranchName());
	    model.put("BRANCH_ID", sessionVO.getUserBranchId());

	    params.put("salesOrderId", (String) params.get("salesOrdId"));
	    EgovMap orderDetail = null;
	    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
	    model.addAttribute("orderDetail", orderDetail);

	    return "payment/billing/ProFormaEditViewPop";
	  }

	@RequestMapping(value = "/chkCustType", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> chkCustType(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("chkCustType param:" + params.toString());
		logger.debug("chkCustType end////");

		List<EgovMap> list = proFormaInvoiceService.chkCustType(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/saveNewProForma.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveNewProForma(@RequestBody Map<String, ArrayList<Object>> params, ModelMap mode, SessionVO sessionVO) {
	    logger.debug("===========================/saveNewProForma.do===============================");
	    logger.debug("==params " + params.toString());
	    logger.debug("===========================/saveNewProForma.do===============================");

	    ReturnMessage message = new ReturnMessage();

	    List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

    	proFormaInvoiceService.saveNewProForma(formList, gridList,  sessionVO);

	    logger.debug("================saveNewProForma - END ================");

    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Sucess.");

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/farCheckConvertFn.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> farCheckConvertFn(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/farCheckConvertFn.do===============================");
	    logger.debug("==params111 " + params.toString());
	    logger.debug("===========================/farCheckConvertFn.do===============================");

	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();

	    proFormaInvoiceService.farCheckConvertFn(params);

	    logger.debug("================farCheckConvertFn - END ================");

	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(params.get("orderNo") + " is " );

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/chkProForma", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> chkProForma(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("chkProForma param:" + params.toString());
		logger.debug("chkProForma end////");

		List<EgovMap> list = proFormaInvoiceService.chkProForma(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectInvoiceBillGroupListProForma.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceBillGroupListProForma(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		logger.debug("params : {}", params);

		String getCustId = invoicePOService.selectCustBillId(params);

		if(getCustId != null){
        	getCustId = getCustId != null ? getCustId : "";
        	params.put("custBillId", getCustId);
        	list = proFormaInvoiceService.selectInvoiceBillGroupListProForma(params);
		}

		return ResponseEntity.ok(list);
	}

}
