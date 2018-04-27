package com.coway.trust.web.sales.order;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.FileDto;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderRegisterController {

	private static Logger logger = LoggerFactory.getLogger(OrderRegisterController.class);

	@Resource(name = "orderRegisterService")
	private OrderRegisterService orderRegisterService;

	@Resource(name = "orderRequestService")
	private OrderRequestService orderRequestService;

	@Resource(name = "customerService")
	private CustomerService customerService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@RequestMapping(value = "/orderRegisterPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "sales/order/orderRegisterPop";
	}


	@RequestMapping(value = "/copyChangeOrder.do")
	public String copyChangeOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		EgovMap result = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		model.put("orderInfo", result);
		model.put("COPY_CHANGE_YN", "Y");
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "sales/order/orderRegisterPop";
	}

	@RequestMapping(value = "/bulkOrderPop.do")
	public String convertToOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		model.put("BULK_ORDER_YN", "Y");
		model.put("preOrdId", params.get("preOrdId"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "sales/order/orderRegisterPop";
	}

	@RequestMapping(value = "/oldOrderPop.do")
	public String oldOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/oldOrderPop";
	}

	@RequestMapping(value = "/orderApprovalPop.do")
	public String orderApprovalPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderApprovalPop";
	}

	@RequestMapping(value = "/cnfmOrderDetailPop.do")
	public String cnfmOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/cnfmOrderDetailPop";
	}

	@RequestMapping(value = "/orderSearchPop.do")
	public String orderSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		model.put("indicator", params.get("indicator"));
		return "sales/order/orderSearchPop";
	}

    @RequestMapping(value = "/selectCustAddJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustAddInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	logger.debug("!@##############################################################################");
    	logger.debug("!@###### custAddId : "+params.get("custAddId"));
    	logger.debug("!@##############################################################################");

    //	EgovMap custAddInfo = orderRegisterService.selectCustAddInfo(params);
    	EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(params);
/*
    	if(custAddInfo != null) {
    		if(CommonUtils.isNotEmpty(custAddInfo.get("postcode"))) {
    			params.put("postCode", custAddInfo.get("postcode"));

    			EgovMap brnchInfo = commonService.selectBrnchIdByPostCode(params);

    			custAddInfo.put("brnchId", brnchInfo.get("brnchId"));
    		}
    	}
*/
    	// 데이터 리턴.
    	return ResponseEntity.ok(custAddInfo);
    }

    @RequestMapping(value = "/checkOldOrderId.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap RESULT = orderRegisterService.checkOldOrderId(params);

    	// 데이터 리턴.
    	return ResponseEntity.ok(RESULT);
    }

/*    @RequestMapping(value = "/selectOldOrderId.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap ordInfo = orderRegisterService.selectOldOrderId(params);

    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }

    @RequestMapping(value = "/selectSvcExpire.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSvcExpire(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap ordInfo = orderRegisterService.selectSvcExpire(params);

    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }

    @RequestMapping(value = "/selectVerifyOldSalesOrderNoValidity.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectVerifyOldSalesOrderNoValidity(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap ordInfo = orderRegisterService.selectVerifyOldSalesOrderNoValidity(params);

    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }*/

    @RequestMapping(value = "/selectCustCntcJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        logger.debug("!@##############################################################################");
        logger.debug("!@###### custAddId : "+params.get("custAddId"));
        logger.debug("!@##############################################################################");

        EgovMap custAddInfo = customerService.selectCustomerViewMainContact(params);

        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }

    @RequestMapping(value = "/selectSrvCntcJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSrvCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        logger.debug("!@##############################################################################");
        logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : "+params.get("custCareCntId"));
        logger.debug("!@##############################################################################");

        EgovMap custAddInfo = orderRegisterService.selectSrvCntcInfo(params);

        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }

    @RequestMapping(value = "/selectStockPriceJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectStockPrice(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        logger.debug("!@##############################################################################");
        logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : "+params.get("custCareCntId"));
        logger.debug("!@##############################################################################");

        EgovMap priceInfo = orderRegisterService.selectStockPrice(params);

        // 데이터 리턴.
        return ResponseEntity.ok(priceInfo);
    }

    @RequestMapping(value = "/selectDocSubmissionList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectDocSubmissionList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectDocSubmissionList(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectPromotionByAppTypeStock.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStock(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectPromotionByAppTypeStock2.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock2(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStock2(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectProductPromotionPriceByPromoStockID.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectProductPromotionPriceByPromoStockID(@RequestParam Map<String, Object> params)
    {
    	EgovMap priceInfo = orderRegisterService.selectProductPromotionPriceByPromoStockID(params);
    	return ResponseEntity.ok(priceInfo);
    }

    @RequestMapping(value = "/selectTrialNo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectTrialNo(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = orderRegisterService.selectTrialNo(params);
    	return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/selectMemberByMemberIDCode.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectMemberByMemberIDCode(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = orderRegisterService.selectMemberByMemberIDCode(params);
    	return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/selectMemberList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectMemberList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = orderRegisterService.selectMemberList(params);
    	return ResponseEntity.ok(codeList);
    }

	/**
	 * 공통 파일 테이블 사용 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/gstEurCertUpload.do", method = RequestMethod.POST)
	public ResponseEntity<FileDto> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, SalesConstants.SALES_GSTEURCERET_SUBPATH, AppConstants.UPLOAD_MAX_FILE_SIZE);

		String param01 = (String) params.get("param01");

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		//serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
		FileDto fileDto = FileDto.create(list, fileGroupKey);

		return ResponseEntity.ok(fileDto);
	}

	@RequestMapping(value = "/copyOrderBulkPop.do")
	public String copyOrderBulkPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		return "sales/order/copyOrderBulkPop";
	}

	@RequestMapping(value = "/registerOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerOrder(@RequestBody OrderVO orderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		//MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
		/*
		String sEurcRefNo = orderVO.getgSTEURCertificateVO().getEurcRefNo();
		FileDto fileDto = null;

		if(CommonUtils.isNotEmpty(sEurcRefNo)) {
    		//if(request.get)
    		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, SalesConstants.SALES_GSTEURCERET_SUBPATH, AppConstants.UPLOAD_MAX_FILE_SIZE);

    		Map<String, Object> params = new HashMap<String, Object>();

    		int fileGroupKey = fileApplication.commonAttach(FileType.WEB, FileVO.createList(list), params);

    		logger.info("fileGroupKey :"+fileGroupKey);

    		fileDto = FileDto.create(list, fileGroupKey);
		}
		orderRegisterService.registerOrder(orderVO, sessionVO, fileDto);
		*/
		orderRegisterService.registerOrder(orderVO, sessionVO);

		//Ex-Trade : 1
		if(orderVO.getSalesOrderMVO().getExTrade() == 1 && CommonUtils.isNotEmpty(orderVO.getSalesOrderMVO().getBindingNo())) {
			logger.debug("@#### Order Cancel START");
			String nowDate = "";

			Date date = new Date();
			SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault(Locale.Category.FORMAT));
			nowDate = df.format(date);

			logger.debug("@#### nowDate:"+nowDate);

			Map<String, Object> cParam = new HashMap<String, Object>();

			cParam.put("salesOrdNo", orderVO.getSalesOrderMVO().getBindingNo());

			EgovMap rMap = orderRegisterService.selectOldOrderId(cParam);

			cParam.put("salesOrdId", String.valueOf(rMap.get("salesOrdId")));
			cParam.put("cmbRequestor", "527");
			cParam.put("dpCallLogDate", nowDate);
			cParam.put("cmbReason", "1993");
			cParam.put("txtRemark", "Auto Cancellation for Ex-Trade");
			cParam.put("txtTotalAmount", "0");
			cParam.put("txtPenaltyCharge", "0");
			cParam.put("txtObPeriod", "0");
			cParam.put("txtCurrentOutstanding", "0");
			cParam.put("txtTotalUseMth", "0");
			cParam.put("txtPenaltyAdj", "0");

			orderRequestService.requestCancelOrder(cParam, sessionVO);
		}

		String msg = "", appTypeName = "";

		switch(orderVO.getSalesOrderMVO().getAppTypeId()) {
    		case SalesConstants.APP_TYPE_CODE_ID_RENTAL :
    			appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT :
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT :
    			appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SPONSOR :
    			appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SERVICE :
    			appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_EDUCATION :
    			appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL :
    			appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS :
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
    			break;
    		default :
    			break;
		}


        msg += "Order successfully saved.<br />";

        if("Y".equals(orderVO.getCopyOrderBulkYN())) {
        	msg += "Order Number : " + orderVO.getSalesOrdNoFirst() + " ~ " + orderVO.getSalesOrderMVO().getSalesOrdNo() + "<br />";
        }
        else {
        	msg += "Order Number : " + orderVO.getSalesOrderMVO().getSalesOrdNo() + "<br />";
        }

        msg += "Application Type : " + appTypeName + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

    @RequestMapping(value = "/selectLoginInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectLoginInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        EgovMap result = orderRegisterService.selectLoginInfo(params);

        // 데이터 리턴.
        return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/selectCheckAccessRight.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCheckAccessRight(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

        EgovMap result = orderRegisterService.selectCheckAccessRight(params, sessionVO);

        // 데이터 리턴.
        return ResponseEntity.ok(result);
    }

	@RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = orderRegisterService.selectProductCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectServicePackageList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectServicePackageList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = orderRegisterService.selectServicePackageList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectServicePackageList2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectServicePackageList2(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = orderRegisterService.selectServicePackageList2(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/prevOrderNoPop.do")
	public String prevOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("custId", params.get("custId"));

		return "sales/order/prevOrderNoPop";
	}
	@RequestMapping(value = "/selectPrevOrderNoList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPrevOrderNoList(@RequestParam Map<String, Object> params) {
		List<EgovMap> result = orderRegisterService.selectPrevOrderNoList(params);
		return ResponseEntity.ok(result);
	}
}
