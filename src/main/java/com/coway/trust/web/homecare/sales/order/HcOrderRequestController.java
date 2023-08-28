package com.coway.trust.web.homecare.sales.order;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

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
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRequestService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderReqApplication;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRequestController.java
 * @Description : Homecare Order Request
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 24.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderRequestController {

	@Resource(name = "hcOrderRequestService")
	private HcOrderRequestService hcOrderRequestService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private OrderReqApplication orderReqApplication;

	@Value("${web.resource.upload.file}")
	private String uploadDir;
	/**
	 * Order Request Popup
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcOrderRequestPop.do")
	public String hcOrderRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		String callCenterYn = "N";

		if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
			callCenterYn = "Y";
		}
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

        params.put("salesOrderId", CommonUtils.nvl(hcOrder.get("srvOrdId")));
        params.put("ordNo", CommonUtils.nvl(hcOrder.get("matOrdNo")));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);		// Mattress Order
		hcOrder = hcOrderListService.selectHcOrderInfo(params);

		EgovMap orderDetail2 = null;
		// has frame order
		if(hcOrder != null) {
			int anoOrdId = CommonUtils.intNvl(hcOrder.get("anoOrdId"));

			if(anoOrdId > 0) {
				Map<String, Object> fraParams = new HashMap<String, Object>();
				fraParams.put("salesOrderId", CommonUtils.nvl(anoOrdId));
				fraParams.put("ordNo", CommonUtils.nvl(hcOrder.get("fraOrdNo")));
				orderDetail2 = orderDetailService.selectBasicInfo(fraParams);		// Mattress Order
			}
		}

		model.put("orderDetail", orderDetail);
		model.put("orderDetail2", orderDetail2);
		model.put("hcOrder", hcOrder);
		model.put("ordReqType", params.get("ordReqType"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);
		model.put("callCenterYn", callCenterYn);
		model.put("userId", sessionVO.getUserId());
	    model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));

		return "homecare/sales/order/hcOrderRequestPop";
	}


	@RequestMapping(value = "/hcOrderRequestPEXPop.do")
	public String hcOrderRequestPEXPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		String callCenterYn = "N";

		if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
			callCenterYn = "Y";
		}
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

		EgovMap orderDetailChose = null;
		orderDetailChose = orderDetailService.selectBasicInfo(params);
//        params.put("salesOrderId", CommonUtils.nvl(hcOrder.get("srvOrdId")));
//        params.put("ordNo", CommonUtils.nvl(hcOrder.get("matOrdNo")));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);		//Chosen Order
		orderDetail.put("basicInfo", orderDetailChose);
		hcOrder = hcOrderListService.selectHcOrderInfo(params);

//		EgovMap orderDetail2 = null;
		// has frame order
//		if(hcOrder != null) {
//			int anoOrdId = CommonUtils.intNvl(hcOrder.get("anoOrdId"));
//
//			if(anoOrdId > 0) {
//				Map<String, Object> fraParams = new HashMap<String, Object>();
//				fraParams.put("salesOrderId", CommonUtils.nvl(anoOrdId));
//				fraParams.put("ordNo", CommonUtils.nvl(hcOrder.get("fraOrdNo")));
//				orderDetail2 = orderDetailService.selectBasicInfo(fraParams);		// Mattress Order
//			}
//		}

		model.put("orderDetail", orderDetail);
//		model.put("orderDetail2", orderDetail2);
		model.put("hcOrder", hcOrder);
		model.put("ordReqType", params.get("ordReqType"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);
		model.put("callCenterYn", callCenterYn);
		model.put("userId", sessionVO.getUserId());
		model.put("isComToPEX", 'Y');

		return "homecare/sales/order/hcOrderRequestPop";
	}

	/**
	 * Request Cancel Order
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcRequestCancelOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcRequestCancelOrder(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage message = hcOrderRequestService.hcRequestCancelOrder(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	/**
	 * Request Check Validation
	 * @Author KR-SH
	 * @Date 2019. 12. 4.
	 * @param params
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/validOCRStus.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> validOCRStus(@RequestParam Map<String, Object> params) throws Exception {
    	ReturnMessage message = hcOrderRequestService.validOCRStus(params);

    	return ResponseEntity.ok(message);
    }

  	/**
  	 * Homecare Order Request - Transfer Ownership
  	 * @Author KR-SH
  	 * @Date 2020. 1. 13.
  	 * @param params
  	 * @return
  	 * @throws Exception
  	 */
	@RequestMapping(value = "/hcReqOwnershipTransfer.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcReqOwnershipTransfer(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMsg = hcOrderRequestService.hcReqOwnershipTransfer(params, sessionVO);

		return ResponseEntity.ok(rtnMsg);
    }

	/**
	 * Homecare Order Request - Product Exchange
	 * @Author KR-SH
	 * @Date 2020. 1. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcRequestProdExch.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcRequestProdExch(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMsg = hcOrderRequestService.hcRequestProdExch(params, sessionVO);

		return ResponseEntity.ok(rtnMsg);
    }

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);


	@RequestMapping(value = "/hcAttachmentFileUpload.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> hcAttachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

	      String err = "";
	      String code = "";
	      List<String> seqs = new ArrayList<>();

	      try{
	           Set set = request.getFileMap().entrySet();
	           Iterator i = set.iterator();

	           while(i.hasNext()) {
	               Map.Entry me = (Map.Entry)i.next();
	               String key = (String)me.getKey();
	               seqs.add(key);
	           }

	      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "Attachment", AppConstants.UPLOAD_MIN_FILE_SIZE, true);

	      LOGGER.debug("list.size : {}", list.size());

	      params.put(CommonConstants.USER_ID, sessionVO.getUserId());

	      orderReqApplication.insertOrderCancelAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

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
}
