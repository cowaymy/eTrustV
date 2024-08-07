package com.coway.trust.web.payment.mobileAppTicket.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.payment.mobileAppTicket.service.MobileAppTicketService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileAppTicketController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 16.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/mobileAppTicket")
public class MobileAppTicketController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileAppTicketController.class);

	@Resource(name = "mobileAppTicketService")
	private MobileAppTicketService mobileAppTicketService;

	/******************************************************
	 * Search Payment
	 *****************************************************/
	/**
	 * mobileAppTicket 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initMobileAppTicket.do")
	public String mobileAppTicket(@RequestParam Map<String, Object> params, ModelMap model) {

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "payment/mobileAppTicket/mobileAppTicketList";
	}

	  @RequestMapping(value = "/selectMobileAppTicketJsonList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectMobileAppTicketJsonList(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {

	    List<EgovMap> customerList = null;

//	    String[] typeId = request.getParameterValues("cmbTypeId"); // Customer Type
	                                                               // 콤보박스 값
//	    String[] cmbCorpTypeId = request.getParameterValues("cmbCorpTypeId"); // Company
	                                                                          // Type
	                                                                          // 콤보박스
	                                                                          // 값
//	    params.put("typeIdList", typeId);
//	    params.put("cmbCorpTypeIdList", cmbCorpTypeId);

	    LOGGER.info("##### customerList START #####");
	    customerList = mobileAppTicketService.selectMobileAppTicketList(params);

	    // 데이터 리턴.
	    return ResponseEntity.ok(customerList);
	  }

	  @RequestMapping(value = "/selectMobileAppTicketStatus.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectMobileAppTicketStatus(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
		  List<EgovMap> mobileAppTicketStatus = null;

		  mobileAppTicketStatus = mobileAppTicketService.selectMobileAppTicketStatus(params);

	    // 데이터 리턴.
	    return ResponseEntity.ok(mobileAppTicketStatus);
	  }
}



