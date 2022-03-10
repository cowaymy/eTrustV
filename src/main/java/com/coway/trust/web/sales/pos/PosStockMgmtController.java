package com.coway.trust.web.sales.pos;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.pos.PosStockService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/posstock")
public class PosStockMgmtController {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosStockMgmtController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private FileApplication fileApplication;


  @Resource(name = "posStockService")
  private PosStockService posStockService;





  @Value("${com.file.upload.path}")
  private String uploadDir;

  @Value("${web.resource.upload.file}")
  private String uploadDirWeb;



  @RequestMapping(value = "/selectPosStockList.do")
  public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    model.addAttribute("branchId", sessionVO.getUserBranchId());


    return "sales/pos/posStockList";
  }




  @RequestMapping(value = "/selectPosStockMgmtViewList.do")
  public String selectPosStockViewList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    LOGGER.debug(params.toString());
    model.put("scnNo", params.get("scnNo"));

    return "sales/pos/posStockMovementViewPop";
  }



  @RequestMapping(value = "/selectPosStockMgmtViewInfo")
  public ResponseEntity<EgovMap> selectPosStockMgmtViewInfo(@RequestParam Map<String, Object> params)
      throws Exception {


	EgovMap  rInfo = new EgovMap();

    List<EgovMap> itemlList = null;
    EgovMap  itemInfo = new EgovMap();


    itemlList = posStockService.selectPosStockMgmtViewList(params);
    itemInfo = posStockService.selectPosStockMgmtViewInfo(params);


    rInfo.put("dataList", itemlList);
    rInfo.put("dataInfo",itemInfo);

    return ResponseEntity.ok(rInfo);
  }



  @RequestMapping(value = "/selectPosStockMgmtAddList.do")
  public String selectPosStockAddList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);


    return "sales/pos/posStockMovementAddPop";
  }


  @RequestMapping(value = "/selectPosStockMgmtAdjList.do")
  public String selectPosStockMgmtAdjList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    model.put("scnNo", params.get("scnNo"));

    return "sales/pos/posStockMovementAdjPop";
  }




  @RequestMapping(value = "/selectPosStockMgmtReturnList.do")
  public String selectPosStockMgmtReturnList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    model.addAttribute("branchId", sessionVO.getUserBranchId());

    LOGGER.debug(sessionVO.getBranchName());
    LOGGER.debug(sessionVO.getDeptName());

    LOGGER.debug(sessionVO.toString());

    return "sales/pos/posStockMovementRetrunPop";
  }



  @RequestMapping(value = "/selectPosStockMgmtNewAdjList.do")
  public String selectPosStockMgmtNewAdjList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    return "sales/pos/posStockMovementNewAdjPop";
  }


  @RequestMapping(value = "/selectPosStockMgmtTransList.do")
  public String selectPosStockMgmtTransList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    model.addAttribute("branchId", sessionVO.getUserBranchId());

    return "sales/pos/posStockMovementTransPop";
  }


  @RequestMapping(value = "/selectPosStockMgmtReceivedList.do")
  public String selectPosStockMgmtReceivedList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    LOGGER.debug(params.toString());
    model.put("scnNo", params.get("scnNo"));

    return "sales/pos/posStockMovementReceivedPop";
  }



  @RequestMapping(value = "/selectPosStockMgmtApprovalList.do")
  public String selectPosStockMgmtApprovalList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    LOGGER.debug(params.toString());
    model.put("scnNo", params.get("scnNo"));

    return "sales/pos/posStockMovementApprovalPop";
  }

  @RequestMapping(value = "/posStockCardRawPop.do")
  public String posStockCardRawPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    return "sales/pos/posStockCardRawPop";
  }





  @RequestMapping(value = "/selectPosStockMgmtReceivedInfo")
  public ResponseEntity<EgovMap> selectPosStockMgmtReceivedInfo(@RequestParam Map<String, Object> params)
      throws Exception {


	EgovMap  rInfo = new EgovMap();

    List<EgovMap> itemlList = null;
    EgovMap  itemInfo = new EgovMap();


    itemlList = posStockService.selectPosStockMgmtViewList(params);
    itemInfo = posStockService.selectPosStockMgmtViewInfo(params);


    rInfo.put("dataList", itemlList);
    rInfo.put("dataInfo",itemInfo);

    return ResponseEntity.ok(rInfo);
  }


  @RequestMapping(value = "/selectItemInvtQty.do" ,method = RequestMethod.POST)
  public ResponseEntity<EgovMap> selectItemInvtQty(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws Exception {


	EgovMap  rInfo = new EgovMap();

    List<EgovMap> itemlList = null;
    EgovMap  itemInfo = new EgovMap();


    itemInfo = posStockService.selectItemInvtQty(params);

    rInfo.put("dataInfo",itemInfo);

    return ResponseEntity.ok(rInfo);
  }





  @RequestMapping(value = "/selectPosStockMgmtAdjInfo")
  public ResponseEntity<EgovMap> selectPosStockMgmtAdjInfo(@RequestParam Map<String, Object> params)
      throws Exception {


	EgovMap  rInfo = new EgovMap();

    List<EgovMap> itemlList = null;
    EgovMap  itemInfo = new EgovMap();


    itemlList = posStockService.selectPosStockMgmtViewList(params);
    itemInfo = posStockService.selectPosStockMgmtViewInfo(params);


    rInfo.put("dataList", itemlList);
    rInfo.put("dataInfo",itemInfo);

    return ResponseEntity.ok(rInfo);
  }

  @RequestMapping(value = "/insertPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertPos(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    Map<String, Object> retunMap = null;
    params.put("scnMoveType", "I");
    retunMap = posStockService.insertPosStock(params);


    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(retunMap.get("scnNo"));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/insertRetrunPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertRetrunPosStock(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    Map<String, Object> retunMap = null;
    params.put("scnMoveType", "R");

    retunMap = posStockService.insertPosStock(params);


    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(retunMap.get("scnNo"));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/insertNewAdjPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertNewAdjPosStock(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    Map<String, Object> retunMap = null;

    params.put("scnMoveType", "A");

    LOGGER.debug(params.toString());
    retunMap = posStockService.insertPosStock(params);


    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(retunMap.get("scnNo"));

    return ResponseEntity.ok(message);

  }




  @RequestMapping(value = "/insertTransPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertTransPosStock(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    Map<String, Object> retunMap = null;
    retunMap = posStockService.insertTransPosStock(params);


    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(retunMap.get("scnNo"));

    return ResponseEntity.ok(message);

  }


  @RequestMapping(value = "/selectPosStockMgmtList")
  public ResponseEntity<List<EgovMap>> selectPosStockMgmtList(@RequestParam Map<String, Object> params)
      throws Exception {

    List<EgovMap> detailList = null;

    detailList = posStockService.selectPosStockMgmtList(params);

    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/selectPosStockMgmtDetailsList")
  public ResponseEntity<List<EgovMap>> selectPosStockMgmtDetailsList(@RequestParam Map<String, Object> params)
      throws Exception {

    List<EgovMap> detailList = null;

    detailList = posStockService.selectPosStockMgmtDetailsList(params);

    return ResponseEntity.ok(detailList);
  }



  @RequestMapping(value = "/updateRecivedPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateRecivedPosStock(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    LOGGER.debug(params.toString());

    Map<String, Object> retunMap = null;

    Map<String, Object> pMap = new HashMap<String, Object>();
    pMap.put("add", ((Map)params.get("data")).get("add"));
    pMap.put("update",  ((Map)params.get("data")).get("update"));
    pMap.put("remove",  ((Map)params.get("data")).get("remove"));

    pMap.put("scnNo",params.get("scnNo"));
    pMap.put("itemStatus",  params.get("itemStatus"));

    pMap.put("userId", sessionVO.getUserId());
    pMap.put("userDeptId", sessionVO.getUserDeptId());
    pMap.put("userName", sessionVO.getUserName());

    retunMap = posStockService.updateRecivedPosStock(pMap);

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }





  @RequestMapping(value = "/updateApprovalPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateApprovalPosStock(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    LOGGER.debug(params.toString());

    Map<String, Object> retunMap = null;

    Map<String, Object> pMap = new HashMap<String, Object>();
    pMap.put("add", ((Map)params.get("data")).get("add"));
    pMap.put("update",  ((Map)params.get("data")).get("update"));
    pMap.put("remove",  ((Map)params.get("data")).get("remove"));

    pMap.put("scnNo",params.get("scnNo"));
    pMap.put("userId", sessionVO.getUserId());
    pMap.put("userDeptId", sessionVO.getUserDeptId());
    pMap.put("userName", sessionVO.getUserName());

    retunMap = posStockService.updateApprovalPosStock(pMap);

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }





  @RequestMapping(value = "/updateAdjPosStock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateAdjPosStock(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    LOGGER.debug(params.toString());

    Map<String, Object> retunMap = null;
    retunMap = posStockService.updateAdjPosStock(params);

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }


  /**
	 * 공통 파일 테이블 사용 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rejectFilleUpload.do", method = RequestMethod.POST)
	public ResponseEntity<FileDto> rejectFilleUpload(MultipartHttpServletRequest request,	@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDirWeb,
				File.separator + "PST" + File.separator + "PST", 1024 * 1024 * 6);

		String param01 = (String) params.get("param01");

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		//serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
		FileDto fileDto = FileDto.create(list, fileGroupKey);

		return ResponseEntity.ok(fileDto);
	}




	  @RequestMapping(value = "/getAtchFile.do")
	  public String getInstAsPSI(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    model.addAttribute("ordNo", params.get("ordNo"));

	    return "sales/order/instAsPSIViewerPop";
	  }



	  @RequestMapping(value = "/selectPosItmList")
	  public ResponseEntity<List<EgovMap>> selectPosFlexiItmList(@RequestParam Map<String, Object> params)
	      throws Exception {

	    List<EgovMap> codeList = null;

	    params.put("stkTypeId", SalesConstants.POS_SALES_NOT_BANK); // 2687
	    codeList = posStockService.selectPosItmList(params);
	    return ResponseEntity.ok(codeList);

	  }


}
