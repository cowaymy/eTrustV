package com.coway.trust.biz.supplement.impl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.supplement.SupplementSubmissionService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.biz.sales.order.vo.SupplementMasterVO;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.vo.SupplementDetailVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT
 * --------------------------------------------------------------------------------------------
 * 14/05/2024 TOMMY 1.0.1 - RE-STRUCTURE SupplementSubmissionServiceImpl
 *********************************************************************************************/
@Service("supplementSubmissionService")
public class SupplementSubmissionServiceImpl
  implements SupplementSubmissionService {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementSubmissionServiceImpl.class );

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "supplementSubmissionMapper")
  private SupplementSubmissionMapper supplementSubmissionMapper;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Override
  public List<EgovMap> selectSupplementSubmissionJsonList( Map<String, Object> params )
    throws Exception {
    return supplementSubmissionMapper.selectSupplementSubmissionJsonList( params );
  }

  @Override
  public List<EgovMap> selectSupplementSubmissionItmList( Map<String, Object> params )
    throws Exception {
    return supplementSubmissionMapper.selectSupplementSubmissionItmList( params );
  }

  @Override
  public int selectExistSupplementSubmissionSofNo( Map<String, Object> params ) {
    return supplementSubmissionMapper.selectExistSupplementSubmissionSofNo( params );
  }

  @Override
  public List<EgovMap> selectSupplementItmList( Map<String, Object> params )
    throws Exception {
    return supplementSubmissionMapper.selectSupplementItmList( params );
  }

  @Override
  public List<EgovMap> chkSupplementStockList( Map<String, Object> params )
    throws Exception {
    List<EgovMap> retunList = null;
    retunList = supplementSubmissionMapper.chkSupplementStockList( params );
    return retunList;
  }

  @Override
  public EgovMap selectMemBrnchByMemberCode( Map<String, Object> params ) {
    return supplementSubmissionMapper.selectMemBrnchByMemberCode( params );
  }

  @Override
  public EgovMap selectMemberByMemberIDCode( Map<String, Object> params ) {
    return supplementSubmissionMapper.selectMemberByMemberIDCode( params );
  }

  @Override
  public Map<String, Object> supplementSubmissionRegister( Map<String, Object> params ) throws Exception {
    List<Object> supplementItemGrid = (List<Object>) params.get( "supplementItmList" );
    Map<String, Object> rtnMap = new HashMap<>();
    try {
      // Get the master sequence and set it in params
      int supplementMasterSeq = supplementSubmissionMapper.getSeqSUP0003M();
      params.put( "seqM", supplementMasterSeq );
      // Insert the master record
      supplementSubmissionMapper.insertSupplementSubmissionMaster( params );
      // Loop through the items and insert each detail record
      for ( int idx = 0; idx < supplementItemGrid.size(); idx++ ) {
        Map<String, Object> itemMap = (Map<String, Object>) supplementItemGrid.get( idx );
        int supplementDetailSeq = supplementSubmissionMapper.getSeqSUP0004D();
        itemMap.put( "seqD", supplementDetailSeq );
        itemMap.put( "seqM", supplementMasterSeq );
        itemMap.put( "crtUsrId", params.get( "crtUsrId" ) );
        supplementSubmissionMapper.insertSupplementSubmissionDetail( itemMap );
      }
      // Set the success response
      rtnMap.put( "logError", "000" );
      rtnMap.put( "message", params.get( "sofNo" ) );
    }
    catch ( Exception e ) {
      // Log the exception (using a logging framework like SLF4J is recommended)
      System.err.println( "Error during supplement submission registration: " + e.getMessage() );
      e.printStackTrace();
      // Set the error response
      rtnMap.put( "logError", "999" );
      rtnMap.put( "message", e.getMessage() );
      // Optionally rethrow the exception if you want it to propagate further
      // throw e;
    }
    return rtnMap;
  }

  @Override
  public List<EgovMap> getAttachList( Map<String, Object> params ) {
    return supplementSubmissionMapper.selectAttachList( params );
  }

  @Override
  public EgovMap selectSupplementSubmissionView( Map<String, Object> params )
    throws Exception {
    return supplementSubmissionMapper.selectSupplementSubmissionView( params );
  }

  @Override
  public List<EgovMap> selectSupplementSubmissionItmView( Map<String, Object> params )
    throws Exception {
    return supplementSubmissionMapper.selectSupplementSubmissionItmView( params );
  }

  @Override
  public EgovMap SP_LOGISTIC_REQUEST_SUPP( Map<String, Object> params ) {
    return (EgovMap) supplementSubmissionMapper.SP_LOGISTIC_REQUEST_SUPP( params );
  }

  @Override
  // @Transactional(rollbackFor = ApplicationException.class)
  public Map<String, Object> updateSubmissionApprovalStatus( Map<String, Object> params ) throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    String submissionStatus = (String) params.get( "stus" );
    SupplementMasterVO supplementMasterVO = new SupplementMasterVO();
    EgovMap supplementSubm = supplementSubmissionMapper.selectSupplementSubmissionView( params );
    List<EgovMap> supplementItem = supplementSubmissionMapper.selectSupplementSubmissionItmView( params );
    try {
      if ( submissionStatus.equals( SalesConstants.SUB_APPOVAL_STATUS_APPROVED ) ) {
        for ( int idx = 0; idx < supplementItem.size(); idx++ ) {
          Map<String, Object> itemMap = (Map<String, Object>) supplementItem.get( idx );
          Map<String, Object> locInfoEntry = new HashMap<String, Object>();
          locInfoEntry.put( "CT_CODE", SalesConstants.SUPPLEMENT_WH_LOC_CODE ); // HQ Warehouse location code
          locInfoEntry.put( "STK_CODE", itemMap.get( "stkId" ) );
          EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY( locInfoEntry );
          if ( locInfo == null ) {
            rtnMap.put( "logError", "999" );
            rtnMap.put( "message",
                        "Insufficient stock available in warehouse. Please try again later when the stock is replenished. "
                          + itemMap.get( "stkCode" ) + " - " + itemMap.get( "stkDesc" ) );
            return rtnMap;
          } else {
            if ( Integer.parseInt( locInfo.get( "availQty" ).toString() ) < Integer.parseInt( itemMap.get( "inputQty" )
                                                                                                     .toString() ) ) {
              rtnMap.put( "logError", "999" );
              rtnMap.put( "message",
                          "Insufficient stock available in warehouse. Please try again later when the stock is replenished. "
                            + itemMap.get( "stkCode" ) + " - " + itemMap.get( "stkDesc" ) );
              return rtnMap;
            }
          }
        }
        insertSupplementMaster( supplementMasterVO, supplementSubm, params );
        insertSupplementDetails( supplementItem, supplementMasterVO.getSupRefId(), params );
        stockBookingSMO( supplementMasterVO.getSupRefNo(), supplementMasterVO.getSupRefId(), params );
        sendEGHLRequest( supplementSubm, supplementMasterVO.getSupRefNo(), supplementMasterVO.getSupRefId(), params );
        supplementSubmissionMapper.updateSupplementSubmissionStatus( params );
        rtnMap.put( "logError", "000" );
        rtnMap.put( "message", supplementMasterVO.getSupRefNo() );
      } else {
        supplementSubmissionMapper.updateSupplementSubmissionStatus( params );
        rtnMap.put( "logError", "001" );
        rtnMap.put( "message", supplementSubm.get( "sofNo" ) );
      }
    } catch ( Exception e ) {
      rtnMap.put( "logError", "999" );
      rtnMap.put( "message", "An error occurred: " + e.getMessage() );
      LOGGER.error( "Error updating submission approval status", e );
    }
    return rtnMap;
  }

  private void insertSupplementMaster( SupplementMasterVO supplementMasterVO, EgovMap supplementSubm, Map<String, Object> params ) {
    int supRefId = supplementSubmissionMapper.getSeqSUP0001M();
    String supRefNo = orderRegisterMapper.selectDocNo( 199 );
    supplementMasterVO.setSupRefId( supRefId );
    supplementMasterVO.setSupRefNo( supRefNo );
    supplementMasterVO.setSupSubmSof( String.valueOf( supplementSubm.get( "sofNo" ) ) );
    supplementMasterVO.setSupRefStus( SalesConstants.STATUS_ACTIVE );
    supplementMasterVO.setSupRefStg( SalesConstants.STATUS_ACTIVE );
    supplementMasterVO.setCustId( CommonUtils.intNvl( supplementSubm.get( "custId" ) ) );
    supplementMasterVO.setCustCntcId( CommonUtils.intNvl( supplementSubm.get( "custCntcId" ) ) );
    supplementMasterVO.setCustDelAddrId( CommonUtils.intNvl( supplementSubm.get( "custDelAddrId" ) ) );
    supplementMasterVO.setCustBillAddrId( CommonUtils.intNvl( supplementSubm.get( "custBillAddrId" ) ) );
    supplementMasterVO.setFlAttId( CommonUtils.intNvl( supplementSubm.get( "atchFileGrpId" ) ) );
    supplementMasterVO.setMemId( CommonUtils.intNvl( supplementSubm.get( "memId" ) ) );
    supplementMasterVO.setMemBrnchId( CommonUtils.intNvl( supplementSubm.get( "memBrnchId" ) ) );
    supplementMasterVO.setSupApplTyp( CommonUtils.intNvl( supplementSubm.get( "supSubmAppTyp" ) ) );
    supplementMasterVO.setSupTtlAmt( CommonUtils.intNvl( supplementSubm.get( "supSubmTtlAmt" ) ) );
    supplementMasterVO.setSupRefRmk( String.valueOf( params.get( "remark" ) ) );
    supplementMasterVO.setDelFlg( SalesConstants.SUB_APPOVAL_DEL_FLG_N );
    supplementMasterVO.setCrtUsrId( CommonUtils.intNvl( params.get( "crtUsrId" ) ) );
    supplementMasterVO.setUpdUsrId( CommonUtils.intNvl( params.get( "updUsrId" ) ) );
    supplementSubmissionMapper.insertSupplementM( supplementMasterVO );
  }

  private void insertSupplementDetails( List<EgovMap> supplementItem, int supRefId, Map<String, Object> params ) {
    for ( EgovMap item : supplementItem ) {
      SupplementDetailVO supplementDetailVO = new SupplementDetailVO();
      int supItmId = supplementSubmissionMapper.getSeqSUP0002D();
      supplementDetailVO.setSupItmId( supItmId );
      supplementDetailVO.setSupRefId( supRefId );
      supplementDetailVO.setSupStkId( CommonUtils.intNvl( item.get( "stkId" ) ) );
      supplementDetailVO.setSupItmQty( CommonUtils.intNvl( item.get( "inputQty" ) ) );
      supplementDetailVO.setSupItmUntprc( (BigDecimal) item.get( "amt" ) );
      supplementDetailVO.setSupItmAmt( (BigDecimal) item.get( "supSubmItmAmt" ) );
      supplementDetailVO.setSupItmTax( BigDecimal.ZERO );
      supplementDetailVO.setSupTotAmt( (BigDecimal) item.get( "totalAmt" ) );
      supplementDetailVO.setDelFlg( SalesConstants.SUB_APPOVAL_DEL_FLG_N );
      supplementDetailVO.setCrtUsrId( CommonUtils.intNvl( params.get( "crtUsrId" ) ) );
      supplementDetailVO.setUpdUsrId( CommonUtils.intNvl( params.get( "updUsrId" ) ) );
      supplementSubmissionMapper.insertSupplementD( supplementDetailVO );
    }
  }

  private void stockBookingSMO( String supRefNo, int supRefId, Map<String, Object> params ) throws Exception {
    Map<String, Object> logPram = new HashMap<>();
    params.put( "supRefId", supRefId );
    logPram.put( "S_NO", supRefNo );
    logPram.put( "RE_TYPE", "STO" );
    // logPram.put( "P_LOC", SalesConstants.SUPPLEMENT_WH_LOC_ID ); // HQ Warehouse location id
    logPram.put( "P_LOC", CommonUtils.nvl(supplementSubmissionMapper.getWhLocId(SalesConstants.SUPPLEMENT_WH_LOC_CODE)) ); // HQ Warehouse location id
    logPram.put( "P_TYPE", "OD01" );
    logPram.put( "P_USER", CommonUtils.intNvl( params.get( "crtUsrId" ) ) );
    supplementSubmissionMapper.SP_LOGISTIC_REQUEST_SUPP( logPram );
    if ( !"000".equals( logPram.get( "p1" ) ) ) {
      rollBackSupplementTransaction( supRefNo, supRefId, params );
      throw new ApplicationException( AppConstants.FAIL,
                                      "SP_LOGISTIC_REQUEST_SUPP - ERRCODE : " + logPram.get( "p1" ) );
      // throw new Exception("SP_LOGISTIC_REQUEST_SUPP - ERRCODE : " + logPram.get("p1"));
    }
  }

  private void sendEGHLRequest( EgovMap supplementSubm, String supRefNo, int supRefId, Map<String, Object> params ) throws Exception {
    LocalDate today = LocalDate.now();
    LocalDate futureDate = today.plusDays( 3 );
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern( "yyyy-MM-dd" );
    String formattedDate = futureDate.format( formatter );
    params.put( "supRefId", supRefId );
    EgovMap supItmString = supplementSubmissionMapper.selectSupplementSubmItmList( params );
    Map<String, Object> eGHLPram = new HashMap<>();
    eGHLPram.put( "custNm", supplementSubm.get( "custName" ) );
    eGHLPram.put( "custCtnt", supplementSubm.get( "telNo" ) );
    eGHLPram.put( "custEmail", supplementSubm.get( "email" ) );
    eGHLPram.put( "ordDesc", supItmString.get( "itmList" ) );
    eGHLPram.put( "ordNo", supRefNo );
    eGHLPram.put( "ordTtlAmt", supplementSubm.get( "supSubmTtlAmt" ) );
    eGHLPram.put( "ordPmtExp", formattedDate );
    eGHLPram.put( "ordPmtLinkEmailInd", "Y" );
    eGHLPram.put( "reqsMod", "CMN" );
    EgovMap rtnData = commonService.reqEghlPmtLink( eGHLPram );
    if ( !"000".equals( rtnData.get( "status" ) ) ) {
      rollBackSupplementTransaction( supRefNo, supRefId, params );
      throw new ApplicationException( AppConstants.FAIL, "eGHL - ERRCODE : " + rtnData.get( "message" ) );
      // throw new Exception("eGHL - ERRCODE : " + rtnData.get("message"));
    }
  }

  private void rollBackSupplementTransaction( String supRefNo, int supRefId, Map<String, Object> params ) throws Exception {
    params.put( "supRefId", supRefId );
    params.put( "supRefNo", supRefNo );
    supplementSubmissionMapper.deleteSupplementM( params );
    supplementSubmissionMapper.deleteSupplementD( params );
    EgovMap requestNo = supplementSubmissionMapper.selectRequestNoBySupRefNo( params );
    if ( requestNo.get( "reqstNo" ) != null ) {
      params.put( "reqstNo", requestNo.get( "reqstNo" ) );
      supplementSubmissionMapper.deleteStockBookingSMO( params );
      supplementSubmissionMapper.updateStockTransferMReq( params );
      supplementSubmissionMapper.updateStockTransferDReq( params );
    }
  }
}
