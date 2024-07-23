package com.coway.trust.web.supplement.cancellation;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.biz.supplement.cancellation.service.SupplementCancellationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT
 * --------------------------------------------------------------------------------------------
 * 14/05/2024 TOMMY 1.0.1 - RE-STRUCTURE SupplementSubmissionController
 *********************************************************************************************/
@Controller
@RequestMapping(value = "/supplement/cancellation")
public class SupplementCancellationController {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementCancellationController.class );

  @Autowired
  private SessionHandler sessionHandler;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "supplementCancellationService")
  private SupplementCancellationService supplementCancellationService;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @RequestMapping(value = "supplementCancellationList.do")
  public String selectSupplementSubmissionList( @RequestParam Map<String, Object> params, ModelMap model )
    throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    List<EgovMap> supRefStus = supplementCancellationService.selectSupRefStus();
    List<EgovMap> supRefStg = supplementCancellationService.selectSupRefStg();
    List<EgovMap> supRtnStus = supplementCancellationService.selectSupRtnStus();

    model.put( "supRefStus", supRefStus );
    model.put( "supRefStg", supRefStg );
    model.put( "supRtnStus", supRtnStus );

    String bfDay = CommonUtils.changeFormat( CommonUtils.getCalDate( -30 ), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1 );
    String toDay = CommonUtils.getFormattedString( SalesConstants.DEFAULT_DATE_FORMAT1 );
    model.put( "bfDay", bfDay );
    model.put( "toDay", toDay );
    return "supplement/cancellation/supplementCancellationList";
  }


  @RequestMapping(value = "/selectSupplementCancellationJsonList")
  public ResponseEntity<List<EgovMap>> selectSupplementSubmissionJsonList( @RequestParam Map<String, Object> params, HttpServletRequest request )
    throws Exception {
    List<EgovMap> listMap = null;

    String supRefStusArray[] = request.getParameterValues( "supRefStus" );
    String supRefStgArray[] = request.getParameterValues( "supRefStg" );
    String rtnStatArray[] = request.getParameterValues( "rtnStat" );

    params.put( "supRefStus", supRefStusArray );
    params.put( "supRefStg", supRefStgArray );
    params.put( "rtnStat", rtnStatArray );

    listMap = supplementCancellationService.selectSupplementCancellationJsonList( params );
    return ResponseEntity.ok( listMap );
  }

  @RequestMapping(value = "/selectSupplementItmList")
  public ResponseEntity<List<EgovMap>> selectSupplementItmList( @RequestParam Map<String, Object> params ) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementCancellationService.selectSupplementItmList( params );
    return ResponseEntity.ok( detailList );
  }

  @RequestMapping(value = "supplementUpdateRtnTrackNoPop.do")
  public String supplementUpdateRtnTrackNoPop( @RequestParam Map<String, Object> params, ModelMap model )
    throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    EgovMap orderInfoMap = null;
    EgovMap cancellationDelInfoMap = null;

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);

    params.put("userId", sessionVO.getUserId());

    model.addAttribute("userId", sessionVO.getUserId());
    model.addAttribute("userBr", sessionVO.getUserBranchId());
    model.addAttribute("cancReqNo", params.get( "cancReqNo" ));
    model.addAttribute("cancReqDt", params.get( "cancReqDt" ));
    model.addAttribute("cancReqBy", params.get( "cancReqBy" ));
    model.addAttribute("supRtnStat", params.get( "supRtnStat" ));
    model.addAttribute("canReqId", params.get( "canReqId" ));

    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);

    return "supplement/cancellation/supplementUpdateRtnTrackNoPop";
  }

  @RequestMapping(value = "/checkDuplicatedTrackNo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> checkDuplicatedTrackNo (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{
    List<EgovMap> itemList = null;

    itemList = supplementCancellationService.checkDuplicatedTrackNo(params);

    return ResponseEntity.ok(itemList);
  }

  @Transactional
  @RequestMapping(value = "/updateRefStgStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateRefStgStatus(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    params.put("userId", sessionVO.getUserId());

    try {
      Map<String, Object> returnMap = supplementCancellationService.updateRefStgStatus(params);
      if ("000".equals(returnMap.get("logError"))) {
        msg += "Parcel tracking number update successfully.";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "Parcel tracking number failed to update. <br />";
        msg += "Errorlogs : " + returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);
    } catch (Exception e) {
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "supplementCancellationViewDetailPop.do")
  public String supplementCancellationViewDetailPop( @RequestParam Map<String, Object> params, ModelMap model )
    throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    EgovMap orderInfoMap = null;
    EgovMap cancellationDelInfoMap = null;

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);

    params.put("userId", sessionVO.getUserId());

    model.addAttribute("userId", sessionVO.getUserId());
    model.addAttribute("userBr", sessionVO.getUserBranchId());
    model.addAttribute("cancReqNo", params.get( "cancReqNo" ));
    model.addAttribute("cancReqDt", params.get( "cancReqDt" ));
    model.addAttribute("cancReqBy", params.get( "cancReqBy" ));
    model.addAttribute("supRtnStat", params.get( "supRtnStat" ));
    model.addAttribute("canReqId", params.get( "canReqId" ));

    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);

    return "supplement/cancellation/supplementCancellationViewDetailPop";
  }

  @RequestMapping(value = "supplementCancellationUpdateReturnQtyPop.do")
  public String supplementCancellationUpdateReturnQtyPop( @RequestParam Map<String, Object> params, ModelMap model )
    throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    EgovMap orderInfoMap = null;
    EgovMap orderStockMap = null;
    EgovMap cancellationDelInfoMap = null;

    orderInfoMap = supplementCancellationService.selectOrderBasicInfo(params);
    orderStockMap = supplementCancellationService.selectOrderStockQty(params);
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);

    params.put("userId", sessionVO.getUserId());

    model.addAttribute("userId", sessionVO.getUserId());
    model.addAttribute("userBr", sessionVO.getUserBranchId());
    model.addAttribute("cancReqNo", params.get( "cancReqNo" ));
    model.addAttribute("cancReqDt", params.get( "cancReqDt" ));
    model.addAttribute("cancReqBy", params.get( "cancReqBy" ));
    model.addAttribute("supRtnStat", params.get( "supRtnStat" ));
    model.addAttribute("canReqId", params.get( "canReqId" ));
    model.addAttribute("supRtnId", params.get( "supRtnId" ));
    model.addAttribute("ttlGoodsQty", orderStockMap);

    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);

    return "supplement/cancellation/supplementCancellationUpdateReturnQtyPop";
  }

  @RequestMapping(value = "/updOrdDelStatDhl.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updOrdDelStaDhlt(@RequestBody Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) throws ParseException, IOException, JSONException {
    ReturnMessage message = new ReturnMessage();
    // SET USER ID
    params.put("userId", sessionVO.getUserId());

    EgovMap rtnData = supplementCancellationService.updOrdDelStatDhl(params);
    message.setCode( "000" );
    message.setMessage(CommonUtils.nvl(rtnData.get( "message" )));

    return ResponseEntity.ok(message);
  }

  @Transactional
  @RequestMapping(value = "/updateReturnGoodsQty.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateReturnGoodsQty(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    params.put("userId", sessionVO.getUserId());

    try {
      Map<String, Object> returnMap = supplementCancellationService.updateReturnGoodsQty(params);
      if ("000".equals(returnMap.get("logError"))) {
        msg += "Parcel tracking number update successfully.";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "Parcel tracking number failed to update. <br />";
        msg += "Errorlogs : " + returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);
    } catch (Exception e) {
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getSupplementRtnItmDetailList")
  public ResponseEntity<List<EgovMap>> getSupplementRtnItmDetailList(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementCancellationService.getSupplementRtnItmDetailList(params);
    return ResponseEntity.ok(detailList);
  }
}
