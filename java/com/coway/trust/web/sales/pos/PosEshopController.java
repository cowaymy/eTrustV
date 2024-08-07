package com.coway.trust.web.sales.pos;

import java.io.File;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.pos.PosEshopService;
import com.coway.trust.biz.sales.pos.PosStockService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.biz.sales.order.PreOrderService;

@Controller
@RequestMapping(value = "/sales/posstock")
public class PosEshopController {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosEshopController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private FileApplication fileApplication;

  @Resource(name = "posEshopService")
  private PosEshopService posEshopService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;


  @Value("${com.file.upload.path}")
  private String uploadDir;

  @Value("${web.resource.upload.file}")
  private String uploadDirWeb;


  @Autowired
  private PreOrderApplication preOrderApplication;


  @RequestMapping(value = "/selectEshopList.do")
  public String selectEshopList(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) throws Exception {

	SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	params.put("userId", sessionVO.getUserId());

	if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
		EgovMap getUserInfo = salesCommonService.getUserInfo(params);
		model.put("memType", getUserInfo.get("memType"));
		model.put("orgCode", getUserInfo.get("orgCode"));
		model.put("grpCode", getUserInfo.get("grpCode"));
		model.put("deptCode", getUserInfo.get("deptCode"));
		model.put("memCode", getUserInfo.get("memCode"));
	}

    String statusArray[] = request.getParameterValues("status");
    params.put("statusArray", statusArray);

    model.addAttribute("branchId", sessionVO.getUserBranchId());


    return "sales/pos/posEshopList";
  }

  @RequestMapping(value = "/eshopItemRegisterPop.do")
  public String eshopItemRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/pos/eshopItemRegisterPop";

  }


  @RequestMapping(value = "/eshopItemEditPop.do")
  public String eshopItemEditPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/pos/eshopItemEditPop";

  }

  @RequestMapping(value = "/eshopShippingPop.do")
  public String eshopShippingPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/pos/eshopShippingPop";

  }

  @RequestMapping(value = "/eshopShippingRegisterPop.do")
  public String eshopShippingRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/pos/eshopShippingRegisterPop";

  }

  @RequestMapping(value = "/selectItemPrice.do" ,method = RequestMethod.POST)
  public ResponseEntity<EgovMap> selectItemPrice(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws Exception {


	EgovMap  rInfo = new EgovMap();

    List<EgovMap> itemlList = null;
    EgovMap  itemInfo = new EgovMap();


    itemInfo = posEshopService.selectItemPrice(params);

    rInfo.put("dataInfo",itemInfo);

    return ResponseEntity.ok(rInfo);
  }

  @RequestMapping(value = "/insertPosEshopItemList.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertPosEshopItemList(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());

    ReturnMessage message = new ReturnMessage();

    try{

        int result = posEshopService.insertPosEshopItemList(params);

        if(result > 0){
           	 message.setCode(AppConstants.SUCCESS);
           	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
       }else{
           	 message.setCode(AppConstants.FAIL);
          	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
       }

    }catch(Exception e){
        	message.setCode(AppConstants.FAIL);
         	message.setMessage(e.toString());
    }

    return ResponseEntity.ok(message);

  }


  @Transactional
  @RequestMapping(value = "/eShopItemUpload.do", method = RequestMethod.POST)
	public ResponseEntity<FileDto> eShopItemUpload(MultipartHttpServletRequest request,	@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles3(request, uploadDirWeb,
				File.separator + "ESHOP" + File.separator + "ESHOP", 1024 * 1024 * 6);

		String param01 = (String) params.get("param01");

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		//serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList2(list), params);
		FileDto fileDto = FileDto.create2(list, fileGroupKey);

		return ResponseEntity.ok(fileDto);
	}


	@RequestMapping(value = "/selectItemList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectItemList (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectItemList(params);

		return ResponseEntity.ok(itemList);

	}

	@RequestMapping(value = "/selectItemList2", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectItemList2 (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectItemList2(params);

		return ResponseEntity.ok(itemList);

	}

	@Transactional
    @RequestMapping(value = "/removeEshopItemList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> removeEshopItemList(@RequestBody Map<String, Object> params,Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put("userId", sessionVO.getUserId());
      params.put("userDeptId", sessionVO.getUserDeptId());
      params.put("userName", sessionVO.getUserName());

	  String searchDelItem = (String) params.get("delArr_addItem");
	  String[] searchItemvalue = searchDelItem.split("∈");

	  params.put("searchitemvalue", searchItemvalue);

      LOGGER.debug(" params removeEshopItemList==dd=>"+params.toString());

      params.put("userId",  sessionVO.getUserId());

      int result = posEshopService.removeEshopItemList(params);

      // Return MSG
      ReturnMessage message = new ReturnMessage();

      if(result > 0){
     	 message.setCode(AppConstants.SUCCESS);
     	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
     }else{
     	message.setCode(AppConstants.FAIL);
    	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
     }

      return ResponseEntity.ok(message);

    }

	@Transactional
    @RequestMapping(value = "/updatePosEshopItemList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updatePosEshopItemList(@RequestBody Map<String, Object> params) throws Exception {
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put("userId", sessionVO.getUserId());
      params.put("userDeptId", sessionVO.getUserDeptId());
      params.put("userName", sessionVO.getUserName());

      Map<String, Object> retunMap = null;

      LOGGER.debug(" params insertPosEshopItemList==dd=>"+params.toString());

      int result = posEshopService.updatePosEshopItemList(params);

      // Return MSG
      ReturnMessage message = new ReturnMessage();

      if(result > 0){
     	 message.setCode(AppConstants.SUCCESS);
     	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
     }else{
     	message.setCode(AppConstants.FAIL);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
     }

      return ResponseEntity.ok(message);

    }

	@Transactional
    @RequestMapping(value = "/insUpdPosEshopShipping.do")
	public ResponseEntity<ReturnMessage> insUpdPosEshopShipping(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

		params.put("crtUserId", session.getUserId());

		LOGGER.debug("param insUpdPosEshopShipping===================>>  " + params.toString());

		int result = posEshopService.insUpdPosEshopShipping(params);

		//Return Message
		ReturnMessage message = new ReturnMessage();

		 if(result > 0){
	    	 message.setCode(AppConstants.SUCCESS);
	    	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	    }else{
	    	message.setCode(AppConstants.FAIL);
	   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	    }

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/selectShippingList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectShippingList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		LOGGER.debug("param selectShippingList===================>>  " + params.toString());

		itemList = posEshopService.selectShippingList(params);

		return ResponseEntity.ok(itemList);

	}

	 @Transactional
	 @RequestMapping(value = "/updatePosEshopShipping.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> updatePosEshopShipping(@RequestBody Map<String, Object> params) throws Exception {
	      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	      params.put("userId", sessionVO.getUserId());
	      params.put("userDeptId", sessionVO.getUserDeptId());
	      params.put("userName", sessionVO.getUserName());

	      Map<String, Object> retunMap = null;

	      LOGGER.debug(" params updatePosEshopShipping==dd=>"+params.toString());

	      int result = posEshopService.updatePosEshopShipping(params);

	      // Return MSG
	      ReturnMessage message = new ReturnMessage();

	      if(result > 0){
	     	 message.setCode(AppConstants.SUCCESS);
	     	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	     }else{
	     	message.setCode(AppConstants.FAIL);
	    	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	     }

	      return ResponseEntity.ok(message);

	  }


	  @RequestMapping(value = "/eshopOrderPop.do")
	  public String eshopOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		int seq = 0;

  		seq=posEshopService.getGrpSeqSAL0327T();

  		LOGGER.debug(" params eshopOrderPop getGrpSeqSAL0327T==dd=>"+seq);

		model.put("userFullName", sessionVO.getUserFullname());
		model.put("cartGrpId",seq);

	    return "sales/pos/eshopOrderPop";

	  }


	  @RequestMapping(value = "/selectItemImageList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectItemImageList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectItemImageList(params);

		return ResponseEntity.ok(itemList);

	}


	@RequestMapping(value = "/selectCatalogList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCatalogList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectCatalogList(params);

		return ResponseEntity.ok(itemList);

	}

	 @Transactional
	 @RequestMapping(value = "/insertItemToCart.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> insertItemToCart(@RequestBody Map<String, Object> params) throws Exception {
	      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	      params.put("userId", sessionVO.getUserId());
	      params.put("userDeptId", sessionVO.getUserDeptId());
	      params.put("userName", sessionVO.getUserName());

	      LOGGER.debug(" params insertItemToCart==dd=>"+params.toString());

	      int result = posEshopService.insertItemToCart(params);

	      // Return MSG
	      ReturnMessage message = new ReturnMessage();

	      if(result > 0){
	     	 message.setCode(AppConstants.SUCCESS);
	     	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	     }else{
	     	message.setCode(AppConstants.FAIL);
	    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	     }

	      return ResponseEntity.ok(message);

	  }

	  @RequestMapping(value = "/selectItemCartList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectItemCartList (@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectItemCartList(params);

		return ResponseEntity.ok(itemList);

	}

	  @RequestMapping(value = "/selectItemCartList2", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectItemCartList2 (@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectItemCartList2(params);

		return ResponseEntity.ok(itemList);

	}

	  @RequestMapping(value = "/selectTotalPrice", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectTotalPrice (@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectTotalPrice(params);

		return ResponseEntity.ok(itemList);

	}


	  @RequestMapping(value = "/selectDefaultBranchList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectDefaultBranchList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectDefaultBranchList(params);

		return ResponseEntity.ok(itemList);

	}

	 @RequestMapping(value = "/selectShippingFee", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectShippingFee (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectShippingFee(params);

		return ResponseEntity.ok(itemList);

	}


	 @Transactional
	 @RequestMapping(value = "/insertPosEshop.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> insertPosEshop(@RequestBody Map<String, Object> params) throws Exception {
	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());
	    params.put("userDeptId", sessionVO.getUserDeptId());
	    params.put("userName", sessionVO.getUserName());




	    Map<String, Object> retunMap = null;
	    retunMap = posEshopService.insertPosEshop(params);


	    // Return MSG
	    ReturnMessage message = new ReturnMessage();

	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	    message.setData(retunMap.get("esnNo"));

	    return ResponseEntity.ok(message);

	  }


	@Transactional
	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

			String err = "";
			String code = "";
			List<String> seqs = new ArrayList<>();

			LocalDate date = LocalDate.now();
			String year    = String.valueOf(date.getYear());
			String month   = String.format("%02d",date.getMonthValue());

			String subPath = File.separator + "sales"
			               + File.separator + "eshop"
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

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles3(request, uploadDirWeb, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);

			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			preOrderApplication.insertPreOrderAttachBiz(FileVO.createList2(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

			params.put("attachFiles", list);
			code = AppConstants.SUCCESS;
			}
			catch(ApplicationException e){
				err = e.getMessage();
				code = AppConstants.FAIL;
			}

			ReturnMessage message = new ReturnMessage();
			message.setCode(code);
			message.setData(params);
			message.setMessage(err);

			return ResponseEntity.ok(message);
		}

	 @RequestMapping(value = "/checkDiffWarehouse", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> checkDiffWarehouse (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.checkDiffWarehouse(params);

		return ResponseEntity.ok(itemList);

	}


	  @RequestMapping(value = "/selectEshopList2", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectEshopList2 (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}

		String statusArray[] = request.getParameterValues("status");
		params.put("statusArray", statusArray);

		LOGGER.debug(" params selectEshopList ==dd=>"+params.toString());

		itemList = posEshopService.selectEshopList(params);

		return ResponseEntity.ok(itemList);

	}

	  @RequestMapping(value = "/selectPosEshopApprovalList.do")
	  public String selectPosEshopApprovalList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());
	    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

	    LOGGER.debug(params.toString());
	    model.put("esnNo", params.get("esnNo"));

	    return "sales/pos/posEshopApprovalPop";
	  }

	  @RequestMapping(value = "/selectPosEshopApprovalViewList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPosEshopApprovalViewList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		LOGGER.debug(" params selectPosEshopApprovalViewList==dd=>"+params.toString());

		itemList = posEshopService.selectPosEshopApprovalViewList(params);

		return ResponseEntity.ok(itemList);

	}

	  @Transactional
	  @RequestMapping(value = "/insertPos.do", method = RequestMethod.POST)
	  public ResponseEntity<Map<String, Object>> insertPos(@RequestBody Map<String, Object> params) throws Exception {
	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());
	    params.put("userDeptId", sessionVO.getUserDeptId());
	    params.put("userName", sessionVO.getUserName());
	    Map<String, Object> retunMap = null;
	    retunMap = posEshopService.insertPos(params);

	    return ResponseEntity.ok(retunMap);

	  }


	  @RequestMapping(value = "/rejectPosEshopPop.do")
	  public String rejectPosEshopPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		  model.put("esnNo", params.get("esnNo"));
		  return "sales/pos/posEshopRejectPop";

	  }

	  @Transactional
	  @RequestMapping(value = "/rejectPos.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> rejectPos(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

			params.put("userId", sessionVO.getUserId());

			int result = posEshopService.rejectPos(params);

			LOGGER.debug(" params rejectPos result==dd=>"+result);
			ReturnMessage message = new ReturnMessage();

		    if (result > 0) {
		    	message.setMessage("ESN update successful.");
		        message.setCode(AppConstants.SUCCESS);
		    } else {
		    	message.setMessage("ESN update failed.");
		        message.setCode(AppConstants.FAIL);
		    }

		    return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/updatePosInfo.do")
	  public String updatePosInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());
	    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

	    LOGGER.debug(params.toString());
	    model.put("esnNo", params.get("esnNo"));

	    return "sales/pos/posEshopUpdateInfoPop";
	  }

	  @Transactional
	  @RequestMapping(value = "/eshopUpdateCourierSvc.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> eshopUpdateCourierSvc(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

			params.put("userId", sessionVO.getUserId());

			int result = posEshopService.eshopUpdateCourierSvc(params);

			ReturnMessage message = new ReturnMessage();

		    if (result > 0) {
		    	message.setMessage("ESN update successful.");
		        message.setCode(AppConstants.SUCCESS);
		    } else {
		    	message.setMessage("ESN update failed.");
		        message.setCode(AppConstants.FAIL);
		    }

		    return ResponseEntity.ok(message);
		}


	  @Transactional
	  @RequestMapping(value = "/completePos.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> completePos(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

			params.put("userId", sessionVO.getUserId());

			int result = posEshopService.completePos(params);

			LOGGER.debug(" params rejectPos result==dd=>"+result);
			ReturnMessage message = new ReturnMessage();

		    if (result > 0) {
		    	message.setMessage("ESN update successful.");
		        message.setCode(AppConstants.SUCCESS);
		    } else {
		    	message.setMessage("ESN update failed.");
		        message.setCode(AppConstants.FAIL);
		    }

		    return ResponseEntity.ok(message);
		}


	  @RequestMapping(value = "/selectEshopWhBrnchList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectEshopWhBrnchList (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectEshopWhBrnchList(params);

		return ResponseEntity.ok(itemList);

	}

	  @RequestMapping(value = "/eshopResultViewPop.do")
	  public String eshopResultViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		model.put("esnNo", params.get("esnNo"));

	    return "sales/pos/eshopResultViewPop";
	  }

	  @RequestMapping(value = "/checkDuplicatedStock", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> checkDuplicatedStock (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.checkDuplicatedStock(params);

		return ResponseEntity.ok(itemList);

	}

	  @RequestMapping(value = "/checkAvailableQtyStock", method = RequestMethod.GET)
	  public ResponseEntity<ReturnMessage> checkAvailableQtyStock (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

		params.put("grpId", params.get("cartGrpId"));

		List<EgovMap> itemList = posEshopService.checkAvailableQtyStock(params);

		String msg="";

		if(itemList !=null && itemList.size()>0){
			for (int i = 0; i < itemList.size(); i++) {
				Map<String, Object> addMap = (Map<String, Object>)itemList.get(i);

				if(i==0){
					msg += addMap.get("itemDesc").toString();
				}
				else{
					msg += ", " + addMap.get("itemDesc").toString();
				}
			}
		}

		//Return Message
		ReturnMessage message = new ReturnMessage();

		 if(itemList !=null && itemList.size()>0){
			message.setCode(AppConstants.FAIL);
		   	message.setMessage(messageAccessor.getMessage(msg));
	    }else{
	    	message.setCode(AppConstants.SUCCESS);
	    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	    }

		return ResponseEntity.ok(message);
	}


	  @Transactional
	  @RequestMapping(value = "/deleteCartItem.do")
		public ResponseEntity<ReturnMessage> deleteCartItem(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

			params.put("crtUserId", session.getUserId());

			int result = posEshopService.deleteCartItem(params);

			//Return Message
			ReturnMessage message = new ReturnMessage();

			 if(result > 0){
		    	 message.setCode(AppConstants.SUCCESS);
		    	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		    }else{
		    	message.setCode(AppConstants.FAIL);
		   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		    }

			return ResponseEntity.ok(message);
		}


	  @RequestMapping(value = "/posEshopRawDataPop.do")
	  public String posEshopRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3,
	        SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);

	    return "sales/pos/posEshopRawDataPop";
	  }

	  @RequestMapping(value = "/posEshopStockPop.do")
	  public String posEshopStockPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    	    model.put("bfDay", bfDay);
    	    model.put("toDay", toDay);
    	    return "sales/pos/posEshopStockPop";
	  }

	  @RequestMapping(value = "/posEshopPaymentConfirmationPop.do")
	  public String posEshopPaymentConfirmationPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    	    model.put("paymentInfo", new Gson().toJson(posEshopService.selectPaymentInfo(params).get(0)));
    	    return "sales/pos/posEshopPaymentConfirmationPop";
	  }

	  @RequestMapping(value = "/checkValidationEsn")
	  public ResponseEntity<String> checkValidationEsn(@RequestParam Map<String, Object> params) throws Exception {
	    return ResponseEntity.ok(new Gson().toJson(posEshopService.checkValidationEsn(params).get(0)));
	  }

	   public void deactivate(Map<String, Object> params){
		   posEshopService.deactivatePaymentAndEsn(params);
		   posEshopService.revertFloatingStockLOG0106M(params);
	   }

	   @Transactional
	   @RequestMapping(value = "/deactivatePayment.do", method = RequestMethod.POST)
	   public ResponseEntity<ReturnMessage> deactivatePayment(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		    ReturnMessage message = new ReturnMessage();
			params.put("userId", sessionVO.getUserId());

			deactivate(params);

			message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("This ESN has been cancelled");
			message.setData(params);
			return ResponseEntity.ok(message);
	   }

	  @Transactional
	  @RequestMapping(value = "/confirmPayment.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> confirmPayment(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		  ReturnMessage message = new ReturnMessage();
			params.put("userId", sessionVO.getUserId());
			int result = 0;

			try{
				 result = posEshopService.confirmPayment(params);

				 if(result > 0){
			    	 message.setCode(AppConstants.SUCCESS);
			    	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			     }else{
			    	deactivate(params);
			    	message.setCode(AppConstants.FAIL);
			   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			    }
			}
			catch(Exception e){
				deactivate(params);
				message.setCode(AppConstants.FAIL);
		   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
			 message.setData(params);
			 return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/selectEshopStockList")
	  public ResponseEntity<List<EgovMap>> selectEshopStockList(@RequestParam Map<String, Object> params) throws Exception {
	    LOGGER.debug("===========> {} " + params);
		  return ResponseEntity.ok(posEshopService.selectEshopStockList(params));
	  }




	  @RequestMapping(value = "/selectEshopWhSOBrnchList")
	  public ResponseEntity<List<EgovMap>> selectEshopWhSOBrnchList() throws Exception {

	    List<EgovMap> codeList = null;

	    codeList = posEshopService.selectEshopWhSOBrnchList();

	    return ResponseEntity.ok(codeList);

	  }


	  @RequestMapping(value = "/selectWhSOBrnchItemList")
	  public ResponseEntity<List<EgovMap>> selectWhSOBrnchItemList() throws Exception {

	    List<EgovMap> codeList = null;

	    codeList = posEshopService.selectWhSOBrnchItemList();

	    return ResponseEntity.ok(codeList);

	  }
}
