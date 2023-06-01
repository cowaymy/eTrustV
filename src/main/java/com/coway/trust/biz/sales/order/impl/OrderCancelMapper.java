package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderCancelMapper")
public interface OrderCancelMapper {

  /**
   * 글 목록을 조회한다.
   *
   * @param searchVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  List<EgovMap> orderCancellationList(Map<String, Object> params);

  /**
   * orderCancelStatus
   *
   * @param -
   * @return combo box
   * @exception Exception
   *              KV cancellation status
   */
  List<EgovMap> orderCancelStatus(Map<String, Object> params);

  /**
   * orderCancelFeedback
   *
   * @param -
   * @return combo box
   * @exception Exception
   *              KV cancellation Feedback
   */
  List<EgovMap> orderCancelFeedback(Map<String, Object> params);

  /**
   * DSC BRANCH
   *
   * @param -
   * @return combo box
   * @exception Exception
   */
  List<EgovMap> dscBranch(Map<String, Object> params);

  /**
   * Cancellation Request Information.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  EgovMap cancelReqInfo(Map<String, Object> params);

  /**
   * Cancellation Log Transaction
   *
   * @param
   * @return 글 상세
   * @exception Exception
   */
  List<EgovMap> cancelLogTransctionList(Map<String, Object> params);

  /**
   * Product Return Transaction
   *
   * @param
   * @return 글 상세
   * @exception Exception
   */
  List<EgovMap> productReturnTransctionList(Map<String, Object> params);

  /**
   * Assign CT - New Cancellation Log Result ComboBox
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> selectAssignCT(Map<String, Object> params);

  /**
   * Assign CT - New Cancellation Log Result ComboBox
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> selectFeedback(Map<String, Object> params);

  /**
   * Assignment CT Information.
   *
   * @param REF_ID,
   *          TYPE_ID
   * @return 글 상세
   * @exception Exception
   */
  EgovMap ctAssignmentInfo(Map<String, Object> params);

  /**
   *
   *
   * @param vo
   *
   * @return 조회한 글
   * @exception Exception
   */
  void updateCancelCCR0006D(Map<String, Object> params);

  void updateCancelSAL0071D(Map<String, Object> params);

  void insertOrdReactiveFee(Map<String, Object> params);

  void updateCancelSAL0001D(Map<String, Object> params);

  void insertCancelLOG0013D(Map<String, Object> params);

  void insertCancelLOG0038D(Map<String, Object> params);

  /**
   * Cancellation Sales master info.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  EgovMap newSearchCancelSAL0001D(Map<String, Object> params);

  /**
   * Cancellation Sales master info.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  EgovMap newSearchCancelSAL0046D(Map<String, Object> params);

  /**
   * Cancellation Sales master info.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  String crtSeqLOG0031D();

  /**
   * Cancellation Sales master info.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  String crtSeqLOG0038D();

  /**
   * @param vo
   *
   * @return 조회한 글
   * @exception Exception
   */
  void updateCancelSAL0020D(Map<String, Object> params);

  void updReservalCancelSAL0020D(Map<String, Object> params);

  void insertCancelCCR0006D(Map<String, Object> params);

  /**
   * Cancellation Sales master info.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  EgovMap newSearchCancelSAL0020D(Map<String, Object> params);

  String crtSeqLOG0037D();

  void insertCancelLOG0037D(Map<String, Object> params);

  void updateCancelLOG0038D(Map<String, Object> params);

  /**
   * Cancellation Sales master info.
   *
   * @param REQ_ID
   * @return 글 상세
   * @exception Exception
   */
  EgovMap cancelCtLOG0038D(Map<String, Object> params);

  /**
   * Assign CT Bulk
   *
   * @param params
   * @return
   * @exception Exception
   * @author
   */
  List<EgovMap> ctAssignBulkList(Map<String, Object> params);

  void insertBulkLOG0037D(Map<String, Object> params);

  void updateBulkLOG0038D(Map<String, Object> params);

  List<EgovMap> getRetReasonList(Map<String, Object> params);

  List<EgovMap> getBranchList(Map<String, Object> params);

  int selRcdTms(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params);

  int chkSubPromo(Map<String, Object> params);

  int chkMainPromo(Map<String, Object> params);

  EgovMap revSubCboPckage(Map<String, Object> params);

  EgovMap revMainCboPckage(Map<String, Object> params);

  void insertSAL0254D(Map<String, Object> params);

  EgovMap select3MonthBlockList(Map<String, Object> params);

  List<EgovMap> productRetReason(Map<String, Object> params);

  List<EgovMap> rsoStatus(Map<String, Object> params);

  int crtSeqSAL0346D();

  void insertDeductSAL0236D(Map<String, Object> params);

  int crtSeqSAL0236D();

  void updatePaymentChannelvRescue(Map<String, Object> params);

  void insertCancelSAL0346D(Map<String, Object> saveParam);

  void updateECashInfo(SalesOrderMVO salesOrderMVO);

  void updateEmailSentCount(Map<String, Object> params);

  void updateCancelSAL0349D(Map<String, Object> params);

}
