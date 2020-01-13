package com.coway.trust.web.payment.report.controller;

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

import com.coway.trust.biz.payment.report.CCDReportService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CCDReportController.java
 * @Description : CCDReportController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 30.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/payment/report")
public class CCDReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CCDReportController.class);

	@Resource(name = "ccdReportService")
	private CCDReportService ccdReportService;

    @Autowired
    private MessageSourceAccessor messageAccessor;


	 /**
	 * customerTypeNPayChannelReportList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerTypeNPayChannelReportList.do")
	public String customerTypeNPayChannelReportList(@RequestParam Map<String, Object> params, ModelMap model) {

//		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);

//		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "payment/report/customerTypeNPayChannelReportList";
	}

	 /**
	 * selectCustomerTypeNPayChannelReportJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCustomerTypeNPayChannelReportJsonList.do", method = RequestMethod.GET)
	  public ResponseEntity<Map<String, Object>> selectCustomerTypeNPayChannelReporJsonList(@RequestParam Map<String, Object> params,
		HttpServletRequest request, ModelMap model) {
		List<EgovMap> customerTypeNPayChannelReporJsonList = null;
		LOGGER.info("##### selectCustomerTypeNPayChannelReporJsonList START #####");
		Map<String, Object> dataList = ccdReportService.selectCustomerTypeNPayChannelReportJsonList(params);

        // 데이터 리턴.
        return ResponseEntity.ok(dataList);
	  }

	 /**
	 * issuerBankReportList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/issuerBankReportList.do")
	public String issuerBankReportList(@RequestParam Map<String, Object> params, ModelMap model) {

//		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);

//		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "payment/report/issuerBankReportList";
	}

	 /**
	 * selectIssuerBankJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectIssuerBankJsonList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectIssuerBankReportJsonList(@RequestBody Map<String, Object> params, Model model) {
		LOGGER.info("++++ selectIssuerBankReportJsonList ::");

		Map<String, Object> dataList = ccdReportService.selectIssuerBankReportJsonList(params);

		return ResponseEntity.ok(dataList);

//		List<EgovMap> dataList = ccdReportService.selectIssuerBankReportJsonList(params);
//		ReturnMessage message = new ReturnMessage();
//		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		message.setDataList(dataList);
//		return ResponseEntity.ok(message);
	}


	 /**
	 * actualPaymentTypeSummaryReportList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/actualPaymentTypeSummaryReportList.do")
	public String typeSummaryReportList(@RequestParam Map<String, Object> params, ModelMap model) {

//		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);

//		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "payment/report/actualPaymentTypeSummaryReportList";
	}


	 /**
	 * selectActualPaymentTypeSummaryReportJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectActualPaymentTypeSummaryReportJsonList.do", method = RequestMethod.GET)
	  public ResponseEntity<Map<String, Object>> selectActualPaymentTypeSummaryReportJsonList(@RequestParam Map<String, Object> params,
		HttpServletRequest request, ModelMap model) {
		List<EgovMap> customerTypeNPayChannelReporJsonList = null;
		LOGGER.info("##### selectActualPaymentTypeSummaryReportJsonList START #####");
		Map<String, Object> dataList = ccdReportService.selectActualPaymentTypeSummaryReportJsonList(params);

      // 데이터 리턴.
      return ResponseEntity.ok(dataList);
	  }
}



