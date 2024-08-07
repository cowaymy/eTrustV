package com.coway.trust.web.sales.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.biz.sales.order.OrderConversionService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderConversionController {

	private static final Logger logger = LoggerFactory.getLogger(OrderConversionController.class);

	@Resource(name = "orderConversionService")
	private OrderConversionService orderConversionService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private LargeExcelService largeExcelService;

	/**
	 * 화면 호출. orderConversionList
	 */
	@RequestMapping(value = "/orderConversionList.do")
	public String orderConversionList(@RequestParam Map<String, Object>params, ModelMap model) {

		return "sales/order/orderConversionList";
	}


	/**
	 * 화면 호출. -Conversion List (데이터조회)
	 */
	@RequestMapping(value = "/orderConversionJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderConversionJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] stusIdList = request.getParameterValues("cmbBatchStatus");
		String[] convStusIdList = request.getParameterValues("cmbConvStatus");
		String[] convStusFrList = request.getParameterValues("cmbStatusFr");
		String[] convStusToList = request.getParameterValues("cmbStatusTo");
		params.put("stusIdList", stusIdList);
		params.put("convStusIdList", convStusIdList);
		params.put("convStusFrList", convStusFrList);
		params.put("convStusToList", convStusToList);

		List<EgovMap> conversionList = orderConversionService.orderConversionList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(conversionList);
	}


	/**
	 * 화면 호출. - Conversion Info
	 */
	@RequestMapping(value = "/conversionDetailPop.do")
	public String conversionDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		EgovMap cnvrInfo = orderConversionService.orderConversionView(params);

		List<EgovMap> orderCnvrInvalidItmList = orderConversionService.orderCnvrInvalidItmList(params);
		List<EgovMap> orderCnvrValidItmList = orderConversionService.orderCnvrValidItmList(params);
		List<EgovMap> conversionItmList = orderConversionService.orderConversionViewItmList(params);

		int invalidRows = orderCnvrInvalidItmList.size();
		int validRows = orderCnvrValidItmList.size();
		int allRows = conversionItmList.size();

		logger.info("##### invalidRows #####" +invalidRows);
		logger.info("##### validRows #####" +validRows);

		model.addAttribute("cnvrInfo", cnvrInfo);
		model.addAttribute("invalidRows", invalidRows);
		model.addAttribute("validRows", validRows);
		model.addAttribute("allRows", allRows);

		return "sales/order/orderConversionDetailPop";
	}


	/**
	 * 화면 호출. -Conversion Item List (데이터조회)
	 */
	@RequestMapping(value = "/orderConvertViewItmJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderConversionViewItmList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = orderConversionService.orderConversionViewItmList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrItmList);
	}

	@RequestMapping(value = "/orderCnvrValidItmList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderCnvrValidItmJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrValidItmList = orderConversionService.orderCnvrValidItmList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrValidItmList);
	}

	@RequestMapping(value = "/orderCnvrInvalidItmJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderCnvrInvalidItmJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrInvalidItmList = orderConversionService.orderCnvrInvalidItmList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrInvalidItmList);
	}

	@RequestMapping(value = "/orderConvertItmRemove.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> orderConvertItmRemove(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		params.put("rsItmStusId", 8);

		orderConversionService.delCnvrItmSAL0073D(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		// 데이터 리턴.
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updCnvrConfirm.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updCnvrConfirm(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		params.put("rsStusId", 4);

		orderConversionService.updCnvrConfirm(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		// 데이터 리턴.
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updCnvrDeactive.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updCnvrDeactive(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		params.put("rsStusId", 8);

		orderConversionService.updCnvrDeactive(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		// 데이터 리턴.
		return ResponseEntity.ok(message);
	}


	/**
	 * 화면 호출. orderConversion New
	 */
	@RequestMapping(value = "/orderConvertNewPop.do")
	public String orderConvertNewPop(@RequestParam Map<String, Object>params, ModelMap model) {
		logger.info("###################### New ###############");
		return "sales/order/orderConvertNewPop";
	}


	@RequestMapping(value = "/chkNewCnvrList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> chkNewCnvrList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("in  saveNewCnvrList ");

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());

		List<EgovMap> chkList = orderConversionService.chkNewCnvrList(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(chkList);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}


	@RequestMapping(value = "/saveNewConvertList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveNewConvertList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());

		orderConversionService.saveNewConvertList(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);
	}

	@RequestMapping(value="/orderConversionRawDataPop.do")
	public String orderConversionRawDataPop(){

		return "sales/order/orderConversionRawDataPop";
	}

	@RequestMapping(value="/orderConversionSummaryReportPop.do")
	public String orderConversionSummaryReportPop(){

		return "sales/order/orderConversionSummaryReportPop";
	}

	//@RequestMapping(value = "/payModeConversion.do")
	//public String payModeConversion(@RequestParam Map<String, Object>params, ModelMap model) {

	//	return "sales/order/payModeConversion";
	//}

	@RequestMapping(value = "/savePayConvertList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savePayConvertList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());

		orderConversionService.savePayConvertList(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/chkPayCnvrList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> chkPayCnvrList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("in  chkPayCnvrList ");

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());

		List<EgovMap> chkList = orderConversionService.chkPayCnvrList(params);

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(chkList);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/paymodeConversionList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymodeConversionList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] convStusFrList = request.getParameterValues("cmbStatusFr");
		String[] convStusToList = request.getParameterValues("cmbStatusTo");
		params.put("convStusFrList", convStusFrList);
		params.put("convStusToList", convStusToList);

		List<EgovMap> conversionList = orderConversionService.paymodeConversionList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(conversionList);
	}

	@RequestMapping(value = "/paymodeConversionList.do")
	public String paymodeConversionList(@RequestParam Map<String, Object>params, ModelMap model) {

		return "sales/order/payModeConversionList";
	}

	@RequestMapping(value = "/paymodeConversionDetailPop.do")
	public String paymodeConversionDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		EgovMap cnvrInfo = orderConversionService.paymodeConversionView(params);

		//List<EgovMap> orderCnvrInvalidItmList = orderConversionService.orderCnvrInvalidItmList(params);
		//List<EgovMap> orderCnvrValidItmList = orderConversionService.orderCnvrValidItmList(params);
		//List<EgovMap> conversionItmList = orderConversionService.orderConversionViewItmList(params);

		//int invalidRows = orderCnvrInvalidItmList.size();
		//int validRows = orderCnvrValidItmList.size();
		//int allRows = conversionItmList.size();

		//logger.info("##### invalidRows #####" +invalidRows);
		//logger.info("##### validRows #####" +validRows);

		model.addAttribute("cnvrInfo", cnvrInfo);
		//model.addAttribute("invalidRows", invalidRows);
		//model.addAttribute("validRows", validRows);
		//model.addAttribute("allRows", allRows);

		return "sales/order/paymodeConversionDetailPop";
	}

	@RequestMapping(value = "/paymodeConvertViewItmJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymodeConvertViewItmJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = orderConversionService.paymodeConversionViewItmList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrItmList);
	}

	@RequestMapping(value = "/paymodeConversion.do")
	public String paymodeConversion(@RequestParam Map<String, Object>params, ModelMap model) {
		return "sales/order/paymodeConvertNewPop";
	}

	@RequestMapping(value = "/paymodeCnvrOrdListRpt.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymodeCnvrOrdListRpt(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> conversionList = orderConversionService.selectOrdPayCnvrList(params);

		return ResponseEntity.ok(conversionList);
	}

	private ExcelDownloadHandler getExcelDownloadHandler(HttpServletResponse response, String fileName,
			String[] columns, String[] titles) {
		ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns, titles);
		return new ExcelDownloadHandler(excelDownloadVO, response);
	}

	@RequestMapping(value = "/paymodeCnvrOrdListRpt2.do")
	public void paymodeCnvrOrdListRpt2(@RequestParam Map<String, Object>params, HttpServletRequest request, HttpServletResponse response) {

		ExcelDownloadHandler downloadHandler = null;

		try {

	        Map<String, Object> map = new HashMap<String, Object>();
			map.put("createStDate", request.getParameter("createStDate") == null ? "01/01/1900" :  request.getParameter("createStDate"));
			map.put("createEnDate", request.getParameter("createEnDate") == null ? "01/01/1900" :  request.getParameter("createEnDate"));

			String[] columns;
	        String[] titles;

	        columns = new String[] { "salesOrdNo","crtDt","oldPmode","newPmode","remark","reqdesc","creator","saleskeyinbranch","platform"};
			titles = new String[] {"ORDERNO","DATE","OLDPAYMODE","NEWPAYMODE","REMARKS","REQDESC","CREATOR", "SALESKEYINBRANCH", "PLATFORM"};

			downloadHandler = getExcelDownloadHandler(response, "OrderListReport.xlsx", columns, titles);

			largeExcelService.downloadOrdPayCnvrList(map, downloadHandler);

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					logger.info(ex.getMessage());
				}
			}
		}
	}

	@RequestMapping(value = "/countPaymodeCnvrExcelList.do", method = RequestMethod.GET)
	public ResponseEntity<Integer> countPaymodeCnvrExcelList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		int cnt = orderConversionService.countPaymodeCnvrExcelList(params);
		return ResponseEntity.ok(cnt);
	}

	@RequestMapping(value = "/orderConversionListPNP.do")
	public String orderConversionListPNPRPS(@RequestParam Map<String, Object>params, ModelMap model) {
	  return "payment/cardpayment/payModeConversionPNPList";
	}

	@RequestMapping(value = "/paymodeConversionPNP.do")
	public String paymodeConversionPNPRPS(@RequestParam Map<String, Object>params, ModelMap model) {
	  return "payment/cardpayment/paymodeConvertNewPNPPop";
	}

	@RequestMapping(value = "/chkPayCnvrListPnp", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> chkPayCnvrListPnp (@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

	  params.put("userId", sessionVO.getUserId());

	  List<EgovMap> chkList = orderConversionService.chkPayCnvrListPnp(params);

	  ReturnMessage message = new ReturnMessage();
	  message.setCode(AppConstants.SUCCESS);
	  message.setData(chkList);
	  message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	  return ResponseEntity.ok(message);

	}

	 @RequestMapping(value = "/savePayConvertListPnp", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> savePayConvertListPnp (@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception{

	    params.put("userId", sessionVO.getUserId());
	    orderConversionService.savePayConvertListPnp(params);

	      ReturnMessage message = new ReturnMessage();
	      message.setCode(AppConstants.SUCCESS);
	      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	      return ResponseEntity.ok(message);
	  }

	 @RequestMapping(value = "/paymodeConversionDetailPNPPop.do")
	  public String paymodeConversionPnpDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {

	   EgovMap cnvrInfo = orderConversionService.paymodeConversionView(params);

	    model.addAttribute("cnvrInfo", cnvrInfo);

	    return "payment/cardpayment/paymodeConversionDetailPNPPop";
	  }


}
