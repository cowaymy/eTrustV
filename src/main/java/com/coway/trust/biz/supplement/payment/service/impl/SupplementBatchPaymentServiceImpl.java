package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.supplement.payment.service.SupplementBatchPaymentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementBatchPaymentService")
public class SupplementBatchPaymentServiceImpl
  extends EgovAbstractServiceImpl
  implements SupplementBatchPaymentService {
  @Resource(name = "supplementBatchPaymentMapper")
  private SupplementBatchPaymentMapper supplementBatchPaymentMapper;

  private static final Logger logger = LoggerFactory.getLogger( SupplementBatchPaymentServiceImpl.class );

  /**
   * selectBatchList(Master Grid) 조회
   *
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> selectBatchList( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.selectBatchList( params );
  }

  @Override
  public EgovMap selectBatchPaymentView( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.selectBatchPaymentView( params );
  }

  @Override
  public List<EgovMap> selectBatchPaymentDetList( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.selectBatchPaymentDetList( params );
  }

  @Override
  public EgovMap selectTotalValidAmt( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.selectTotalValidAmt( params );
  }

  @Override
  public int updRemoveItem( Map<String, Object> params ) {
    //if is eghl record, possible have multiple order tie into one batchId
    this.removeEGHLBatchOrderRecord( params );
    return supplementBatchPaymentMapper.updRemoveItem( params );
  }

  @Override
  public int saveConfirmBatch( Map<String, Object> params ) {
    EgovMap paymentMs = supplementBatchPaymentMapper.selectBatchPaymentMs( params );
    List<EgovMap> supBatchPaymentDtl = supplementBatchPaymentMapper.selectSupBatchPaymentDtl( params );
    int insResult = 0;
    int callResult = -1;
    int returnResult = 0;
    if ( paymentMs != null ) {
      if ( String.valueOf( paymentMs.get( "batchPayType" ) ).equals( "577" ) ) {
        // CALL PROCEDURE
        supplementBatchPaymentMapper.callCnvrSupBatchPay( params );
        callResult = Integer.parseInt( String.valueOf( params.get( "p1" ) ) );
      }
      if ( callResult > -1 ) {
        if ( String.valueOf( paymentMs.get( "batchStusId" ) ).equals( "1" )
          && String.valueOf( paymentMs.get( "cnfmStusId" ) ).equals( "44" ) ) {
          insResult = supplementBatchPaymentMapper.saveConfirmBatch( params );
        }
      }
    }
    if ( insResult > 0 && callResult > -1 ) {
      //UPDATE SUP0001M.SUP_REF_STG FROM 1 TO 2
      if ( supBatchPaymentDtl.size() > 0 ) {
        for ( int i = 0; i < supBatchPaymentDtl.size(); i++ ) {
          Map<String, Object> updMap = (Map<String, Object>) supBatchPaymentDtl.get( i );
          updMap.put( "userId", params.get( "userId" ).toString() );
          supplementBatchPaymentMapper.updSupplementOrdStage( updMap );
        }
      }
      //for eGHL record checking and update
      returnResult = 1;
    }
    else {
      returnResult = 0;
    }
    return returnResult;
  }

  @Override
  public EgovMap selectBatchPaymentDs( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.selectBatchPaymentDs( params );
  }

  @Override
  public int saveDeactivateBatch( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.saveDeactivateBatch( params );
  }

  @Override
  public EgovMap selectBatchPaymentMs( Map<String, Object> params ) {
    return supplementBatchPaymentMapper.selectBatchPaymentMs( params );
  }

  @Override
  public int saveBatchPaymentUpload( Map<String, Object> master, List<Map<String, Object>> detailList ) {
    int insResult = 0;
    int mastetSeq = 0;
    if ( master.get( "isBatch" ) != null && master.get( "batchId" ) != null ) {
      mastetSeq = Integer.parseInt( master.get( "batchId" ).toString() );
    }
    else {
      mastetSeq = supplementBatchPaymentMapper.getPAY0360MSEQ();
    }
    master.put( "batchId", mastetSeq );
    master.put( "delFlg", "N" );
    int mResult = supplementBatchPaymentMapper.saveBatchPayMaster( master );
    if ( mResult > 0 && detailList.size() > 0 ) {
      List buLit = new ArrayList();
      for ( int i = 0; i < detailList.size(); i++ ) {
        int detailSeq = supplementBatchPaymentMapper.getPAY0359DSEQ();
        detailList.get( i ).put( "detId", detailSeq );
        detailList.get( i ).put( "batchId", mastetSeq );
        detailList.get( i ).put( "jomPay", master.get( "jomPay" ) );
        detailList.get( i ).put( "delFlg", "N" );
        buLit.add( detailList.get( i ) );
      }
      master.put( "list", buLit );
      supplementBatchPaymentMapper.saveBatchPayDetailList( master );
      //CALL PROCEDURE
      insResult = supplementBatchPaymentMapper.callSupBatchPayVerifyDet( master );
      if ( !master.get( "p1" ).toString().equals( "1" ) ) {
        mastetSeq = -1;
      }
    }
    return mastetSeq;
  }

  @Override
  public String selectBatchPayCardModeId( String cardModeCode ) {
    return supplementBatchPaymentMapper.selectBatchPayCardModeId( cardModeCode );
  }

  @Override
  public int removeEGHLBatchOrderRecord( Map<String, Object> params ) {
    int count = supplementBatchPaymentMapper.checkIfIsEGHLRecord( params );
    if ( count > 0 ) {
      supplementBatchPaymentMapper.removeEGHLBatchOrderRecord( params );
    }
    return 1;
  }

  @Override
  public List<EgovMap> getPaymentMode() {
    return supplementBatchPaymentMapper.getPaymentMode();
  }

  @Override
  public List<EgovMap> getPaymentBatStatus() {
    return supplementBatchPaymentMapper.getPaymentBatStatus();
  }

  @Override
  public List<EgovMap> getPaymentBatConfirmtStatus() {
    return supplementBatchPaymentMapper.getPaymentBatConfirmtStatus();
  }
}
