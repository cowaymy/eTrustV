package com.coway.trust.web.homecare.sales;

import java.util.List;
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
import com.coway.trust.biz.homecare.sales.htOrderRegisterService;
import com.coway.trust.biz.homecare.sales.vo.HTOrderVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.PageAuthVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/homecare/sales")
public class htOrderRegisterController {

	private static Logger logger = LoggerFactory.getLogger(htOrderRegisterController.class);

	@Resource(name = "htOrderRegisterService")
	private htOrderRegisterService htOrderRegisterService;

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

	@RequestMapping(value = "/htOrderRegisterPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.info("############## page auth: " + params.toString());

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		if (params.get("pageAuth") != null){
			model.put("FREE_TRIAL_AUTH", params.get("pageAuth"));
		}

		return "homecare/sales/htOrderRegisterPop";
	}


/*	@RequestMapping(value = "/copyChangeOrder.do")
	public String copyChangeOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		EgovMap result = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		model.put("orderInfo", result);
		model.put("COPY_CHANGE_YN", "Y");
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "sales/order/orderRegisterPop";
	}*/

/*	@RequestMapping(value = "/bulkOrderPop.do")
	public String convertToOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		model.put("BULK_ORDER_YN", "Y");
		model.put("preOrdId", params.get("preOrdId"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "sales/order/orderRegisterPop";
	}
*/
/*	@RequestMapping(value = "/oldOrderPop.do")
	public String oldOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/oldOrderPop";
	}*/

	@RequestMapping(value = "/orderApprovalPop.do")
	public String orderApprovalPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderApprovalPop";
	}

	@RequestMapping(value = "/cnfmHTOrderDetailPop.do")
	public String cnfmHTOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "homecare/sales/cnfmHTOrderDetailPop";
	}

	@RequestMapping(value = "/orderSearchPop.do")
	public String orderSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		model.put("indicator", params.get("indicator"));
		return "homecare/sales/htOrderSearchPop";
	}

    @RequestMapping(value = "/selectCustAddJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustAddInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	logger.debug("!@##############################################################################");
    	logger.debug("!@###### custAddId : "+params.get("custAddId"));
    	logger.debug("!@##############################################################################");

    //	EgovMap custAddInfo = htOrderRegisterService.selectCustAddInfo(params);
    	EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(params);

    	if(custAddInfo != null) {
    		if(CommonUtils.isNotEmpty(custAddInfo.get("postcode"))) {
    			params.put("postCode", custAddInfo.get("postcode"));

    		}
    	}

    	// 데이터 리턴.
    	return ResponseEntity.ok(custAddInfo);
    }

/*    @RequestMapping(value = "/checkOldOrderId.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
logger.info("extrade :: " + params.get("exTrade"));
    	EgovMap RESULT;
    	if(params.get("exTrade").equals("2")){
    		RESULT = htOrderRegisterService.checkOldOrderIdICare(params);
    	}else{
    		RESULT = htOrderRegisterService.checkOldOrderId(params);
    	}

    	// 데이터 리턴.
    	return ResponseEntity.ok(RESULT);
    }*/

/*    @RequestMapping(value = "/selectOldOrderId.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap ordInfo = htOrderRegisterService.selectOldOrderId(params);

    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }

    @RequestMapping(value = "/selectSvcExpire.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSvcExpire(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap ordInfo = htOrderRegisterService.selectSvcExpire(params);

    	// 데이터 리턴.
    	return ResponseEntity.ok(ordInfo);
    }

    @RequestMapping(value = "/selectVerifyOldSalesOrderNoValidity.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectVerifyOldSalesOrderNoValidity(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

    	EgovMap ordInfo = htOrderRegisterService.selectVerifyOldSalesOrderNoValidity(params);

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

        EgovMap custAddInfo = htOrderRegisterService.selectSrvCntcInfo(params);

        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }

    @RequestMapping(value = "/selectStockPriceJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectStockPrice(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        logger.debug("!@##############################################################################");
        logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : "+params.get("custCareCntId"));
        logger.debug("!@##############################################################################");

        EgovMap priceInfo = htOrderRegisterService.selectStockPrice(params);

        // 데이터 리턴.
        return ResponseEntity.ok(priceInfo);
    }

    @RequestMapping(value = "/selectDocSubmissionList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectDocSubmissionList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = htOrderRegisterService.selectDocSubmissionList(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectPromotionByAppTypeStock.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = htOrderRegisterService.selectPromotionByAppTypeStock(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectPromotionByAppTypeStock2.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock2(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = htOrderRegisterService.selectPromotionByAppTypeStock2(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectProductPromotionPercentByPromoID.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectProductPromotionPercentByPromoID(@RequestParam Map<String, Object> params)
    {
    	EgovMap priceInfo = htOrderRegisterService.selectProductPromotionPercentByPromoID(params);
    	return ResponseEntity.ok(priceInfo);
    }

    @RequestMapping(value = "/selectTrialNo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectTrialNo(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = htOrderRegisterService.selectTrialNo(params);
    	return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/selectMemberByMemberIDCode.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectMemberByMemberIDCode(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = htOrderRegisterService.selectMemberByMemberIDCode(params);
    	return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/selectMemberList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectMemberList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = htOrderRegisterService.selectMemberList(params);
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

	/*@RequestMapping(value = "/copyOrderBulkPop.do")
	public String copyOrderBulkPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		return "sales/order/copyOrderBulkPop";
	}*/

	@RequestMapping(value = "/registerOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerOrder(@RequestBody HTOrderVO orderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		 logger.info("##### params #####" + orderVO);

		ReturnMessage message = htOrderRegisterService.registerOrder(orderVO, sessionVO);

		return ResponseEntity.ok(message);
	}

    @RequestMapping(value = "/selectLoginInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectLoginInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        EgovMap result = htOrderRegisterService.selectLoginInfo(params);

        // 데이터 리턴.
        return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/selectCheckAccessRight.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCheckAccessRight(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

        EgovMap result = htOrderRegisterService.selectCheckAccessRight(params, sessionVO);

        // 데이터 리턴.
        return ResponseEntity.ok(result);
    }

	@RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = htOrderRegisterService.selectProductCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectServicePackageList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectServicePackageList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = htOrderRegisterService.selectServicePackageList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectServicePackageList2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectServicePackageList2(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = htOrderRegisterService.selectServicePackageList2(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/prevOrderNoPop.do")
	public String prevOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("custId", params.get("custId"));

		return "sales/order/prevOrderNoPop";
	}
	@RequestMapping(value = "/selectPrevOrderNoList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPrevOrderNoList(@RequestParam Map<String, Object> params) {
		List<EgovMap> result = htOrderRegisterService.selectPrevOrderNoList(params);
		return ResponseEntity.ok(result);
	}

    @RequestMapping(value = "/selectProductComponent.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectProductComponent(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> codeList = htOrderRegisterService.selectProductComponent(params);
    	return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectProductComponentDefaultKey.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectProductComponentDefaultKey(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
        EgovMap defaultKey = htOrderRegisterService.selectProductComponentDefaultKey(params);
        // 데이터 리턴.
        return ResponseEntity.ok(defaultKey);
    }

    @RequestMapping(value = "/selectHTCovergPostCode.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectHTCovergPostCode(@RequestParam Map<String, Object> params)
    {
    	EgovMap postCodeInfo = htOrderRegisterService.selectHTCovergPostCode(params);
    	return ResponseEntity.ok(postCodeInfo);
    }
}
