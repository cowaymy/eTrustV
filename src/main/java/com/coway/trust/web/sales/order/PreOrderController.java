/**
 *
 */
package com.coway.trust.web.sales.order;

import java.io.File;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.PreOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class PreOrderController {

	private static Logger logger = LoggerFactory.getLogger(PreOrderController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Resource(name = "preOrderService")
	private PreOrderService preOrderService;

	@Autowired
	private PreOrderApplication preOrderApplication;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "commonService")
	private CommonService commonService;


	@RequestMapping(value = "/preOrderList.do")
	public String preOrderList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){

			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		String bfDay = CommonUtils.changeFormat( CommonUtils.getCalDate( -30 ), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1 );

    model.put("bfDay", bfDay );
		model.put("toDay", toDay);
		model.put("isAdmin", "true");
		EgovMap branchTypeRes = salesCommonService.getUserBranchType(params);
		if (branchTypeRes != null) {
			model.put("branchType", branchTypeRes.get("codeId"));
		}
		model.addAttribute("userRoleId", sessionVO.getRoleId());

		return "sales/order/preOrderList";
	}

	@RequestMapping(value = "/preOrderModifyPop.do")
	public String preOrderModifyPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

		//[Tap]Basic Info
		EgovMap result = preOrderService.selectPreOrderInfo(params);

//		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
//
//		model.put("toDay", toDay);
		model.put("preOrderInfo", result);

		EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

        String dayFrom = "", dayTo = "";

        if(checkExtradeSchedule!=null){
        	dayFrom = checkExtradeSchedule.get("startDate").toString();
        	dayTo = checkExtradeSchedule.get("endDate").toString();
        }
        else{
        	dayFrom = "20"; // default 20-{month-1}
       	  dayTo = "31"; // default LAST DAY OF THE MONTH
        }

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
					SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("hsBlockDtFrom", dayFrom);
		model.put("hsBlockDtTo", dayTo);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		model.put("userType", sessionVO.getUserTypeId());
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));

		return "sales/order/preOrderModifyPop";
	}

	@RequestMapping(value = "/selectPreOrderList.do")
	public ResponseEntity<List<EgovMap>> selectPreOrderList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		String[] arrAppType      = request.getParameterValues("_appTypeId"); //Application Type
		String[] arrPreOrdStusId = request.getParameterValues("_stusId");    //Pre-Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("_brnchId");   //Key-In Branch
		String[] arrCustType     = request.getParameterValues("_typeId");    //Customer Type

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrPreOrdStusId != null && !CommonUtils.containsEmpty(arrPreOrdStusId)) params.put("arrPreOrdStusId", arrPreOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrCustType     != null && !CommonUtils.containsEmpty(arrCustType))     params.put("arrCustType", arrCustType);

		List<EgovMap> result = preOrderService.selectPreOrderList(params);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectExistSofNo.do")
	public ResponseEntity<EgovMap> selectExistSofNo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		int cnt = preOrderService.selectExistSofNo(params);

		EgovMap result = new EgovMap();

		result.put("IS_EXIST", cnt > 0 ? "true" : "false");

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectExistingMember.do")
	public ResponseEntity<EgovMap> selectExistingMember(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		int cnt = preOrderService.selectExistingMember(params);

		EgovMap result = new EgovMap();

		result.put("IS_EXIST", cnt > 0 ? "true" : "false");

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/preOrderRegisterPop.do")
	public String preOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {
        // Search code List
        model.put("codeList_19", commonService.selectCodeList("19", "CODE_NAME"));
        model.put("codeList_325", commonService.selectCodeList("325"));
        model.put("codeList_415", commonService.selectCodeList("415", "CODE_ID"));
        model.put("codeList_416", commonService.selectCodeList("416", "CODE_ID"));
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
        // Search BranchCodeList
        model.put("branchCdList_1", commonService.selectBranchList("1", "-"));
        model.put("branchCdList_5", commonService.selectBranchList("5", "-"));
        model.put("nextDay", CommonUtils.getAddDay(CommonUtils.getDateToFormat(SalesConstants.DEFAULT_DATE_FORMAT1), 1, SalesConstants.DEFAULT_DATE_FORMAT1));


        EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

        String dayFrom = "", dayTo = "";

        if(checkExtradeSchedule!=null){
        	dayFrom = checkExtradeSchedule.get("startDate").toString();
        	dayTo = checkExtradeSchedule.get("endDate").toString();
        }
        else{
        	dayFrom = "20"; // default 20-{month-1}
       	  dayTo = "31"; // default LAST DAY OF THE MONTH
        }




		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
					SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("hsBlockDtFrom", dayFrom);
		model.put("hsBlockDtTo", dayTo);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);




		return "sales/order/preOrderRegisterPop";
	}

	@RequestMapping(value = "/registerPreOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerPreOrder(@RequestBody PreOrderVO preOrderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		preOrderService.insertPreOrder(preOrderVO, sessionVO);

		String msg = "", appTypeName = "";

		switch(preOrderVO.getAppTypeId()) {
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
        msg += "SOF No : " + preOrderVO.getSofNo() + "<br />";
        msg += "Application Type : " + appTypeName + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/modifyPreOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> modifyPreOrder(@RequestBody PreOrderVO preOrderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		preOrderService.updatePreOrder(preOrderVO, sessionVO);

		String msg = "", appTypeName = "";

		switch(preOrderVO.getAppTypeId()) {
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

        msg += "Order successfully updated.<br />";
        msg += "SOF No : " + preOrderVO.getSofNo() + "<br />";
        msg += "Application Type : " + appTypeName + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/modifyPreOrderStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> modifyPreOrderStatus(@RequestBody PreOrderListVO preOrderListVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		preOrderService.updatePreOrderStatus(preOrderListVO, sessionVO);

		String msg = "Order Status successfully updated.";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateFailPreOrderStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateFailPreOrderFailStatus(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

		preOrderService.updatePreOrderFailStatus(params, sessionVO);

		String msg = "Order Status successfully updated.";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectPreOrderFailStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPreOrderFailStatus( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		List<EgovMap> result = preOrderService.selectPreOrderFailStatus(params) ;

		return ResponseEntity.ok(result);
	}


	@RequestMapping(value = "/convertToOrderPop.do")
	public String convertToOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		EgovMap result = preOrderService.selectPreOrderInfo(params);

		model.put("preOrderInfo", result);
		model.put("CONV_TO_ORD_YN", "Y");
		model.put("preOrdId", params.get("preOrdId"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));

		return "sales/order/orderRegisterPop";
	}

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		LocalDate date = LocalDate.now();
		String year    = String.valueOf(date.getYear());
		String month   = String.format("%02d",date.getMonthValue());

		String subPath = File.separator + "sales"
		               + File.separator + "ekeyin"
		               + File.separator + year
		               + File.separator + month
		               + File.separator + CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3);

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

		//List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);

		logger.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		preOrderApplication.insertPreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

		params.put("attachFiles", list);
		code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectAttachList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getAttachList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> attachList = preOrderService.getAttachList(params) ;

		return ResponseEntity.ok( attachList);
	}

	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		logger.debug("params =====================================>>  " + params);
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		LocalDate date = LocalDate.now();
    String year    = String.valueOf(date.getYear());
    String month   = String.format("%02d",date.getMonthValue());

    String subPath = File.separator + "sales"
                   + File.separator + "ekeyin"
                   + File.separator + year
                   + File.separator + month
                   + File.separator + CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3);

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			//List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			logger.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			preOrderApplication.updatePreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

			params.put("attachFiles", list);
			code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/cnfmPreOrderDetailPop.do")
	public String cnfmPreOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("atchFileGrpId", params.get("atchFileGrpId"));

		return "sales/order/cnfmPreOrderDetailPop";
	}

	   @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.GET)
	   public ResponseEntity<ReturnMessage> chkRcdTms(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	     ReturnMessage message = new ReturnMessage();

	     int noRcd = preOrderService.selRcdTms(params);
	     int cnt = preOrderService.selPreOrdId(params);

	     if (noRcd == 1 && cnt <= 0) {
	       message.setMessage("OK");
	       message.setCode("1");
	     } else {
	       message.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
	       message.setCode("99");
	     }
	     return ResponseEntity.ok(message);
	   }

	   @RequestMapping(value = "/checkOldOrderIdEKeyIn.do", method = RequestMethod.GET)
	   public ResponseEntity<EgovMap> selectOldOrderIdEKeyIn(@RequestParam Map<String, Object> params, ModelMap model)
	       throws Exception {
	     logger.info("extrade :: " + params.get("exTrade"));
	     EgovMap RESULT;
	     if (params.get("exTrade").equals("2")) {
	       RESULT = preOrderService.checkOldOrderIdICareEKeyIn(params);
	     } else {
	       RESULT = preOrderService.checkOldOrderIdEKeyIn(params);
	     }

	     // 데이터 리턴.
	     return ResponseEntity.ok(RESULT);
	   }


	   @RequestMapping(value = "/prevOrderNoPopEKeyIn.do")
	   public String prevOrderNoPopEKeyIn(@RequestParam Map<String, Object> params, ModelMap model) {
		   logger.info("custid :: " + params.get("custId"));
	     model.put("custId", params.get("custId"));
	     //model.put("exTrade", params.get("exTrade"));

	     return "sales/order/prevOrderNoPopEKeyIn";
	   }

}
