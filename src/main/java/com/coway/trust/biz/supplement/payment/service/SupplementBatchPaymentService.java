package com.coway.trust.biz.supplement.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementBatchPaymentService {
  /**
   * Batch Payment List(Master Grid) 조회
   *
   * @param params
   * @return
   */
  List<EgovMap> selectBatchList( Map<String, Object> params );

  /**
   * selectBatchPaymentView 조회
   *
   * @param params
   * @return
   */
  EgovMap selectBatchPaymentView( Map<String, Object> params );

  /**
   * selectBatchPaymentDetList 조회
   *
   * @param params
   * @return
   */
  List<EgovMap> selectBatchPaymentDetList( Map<String, Object> params );

  /**
   * selectTotalValidAmt 조회
   *
   * @param params
   * @return
   */
  EgovMap selectTotalValidAmt( Map<String, Object> params );

  /**
   * updRemoveItem
   *
   * @param params
   * @return
   */
  int updRemoveItem( Map<String, Object> params );

  /**
   * saveItemConfirm
   *
   * @param params
   * @return
   */
  int saveConfirmBatch( Map<String, Object> params );

  /**
   * selectBatchPaymentDs
   *
   * @param params
   * @return
   */
  EgovMap selectBatchPaymentDs( Map<String, Object> params );

  /**
   * saveDeactivateBatch
   *
   * @param params
   * @return
   */
  int saveDeactivateBatch( Map<String, Object> params );

  /**
   * selectBatchPaymentMs
   *
   * @param params
   * @return
   */
  EgovMap selectBatchPaymentMs( Map<String, Object> params );

  /**
   * saveBatchPaymentUpload
   *
   * @param params
   * @return
   */
  int saveBatchPaymentUpload( Map<String, Object> master, List<Map<String, Object>> detailList );

  /**
   * selectBatchPayCardModeId
   *
   * @param params
   * @return
   */
  String selectBatchPayCardModeId( String cardModeCode );

  /**
   * removeEGHLBatchOrderRecord
   *
   * @param params
   * @return
   */
  int removeEGHLBatchOrderRecord( Map<String, Object> params );

  /**
   * getPaymentMode
   *
   * @param params
   * @return
   */
  List<EgovMap> getPaymentMode();

  /**
   * getPaymentBatStatus
   *
   * @param params
   * @return
   */
  List<EgovMap> getPaymentBatStatus();

  /**
   * getPaymentBatConfirmtStatus
   *
   * @param params
   * @return
   */
  List<EgovMap> getPaymentBatConfirmtStatus();
}
