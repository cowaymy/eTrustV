package com.coway.trust.biz.services.bs.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hsManualMapper")
public interface HsManualMapper {

  List<EgovMap> selectHsConfigList(Map<String, Object> params);

  List<EgovMap> selectHsManualList(Map<String, Object> params);

  List<EgovMap> selectHsAssiinlList(Map<String, Object> params);

  EgovMap selectHsAssiinlList_1(Map<String, Object> params);

  List<EgovMap> selectBranchList(Map<String, Object> params);

  List<EgovMap> selectCtList(Map<String, Object> params);

  List<EgovMap> getCdList(Map<String, Object> params);

  List<EgovMap> getCdUpMemList(Map<String, Object> params);

  List<EgovMap> getCdDeptList(Map<String, Object> params);

  List<EgovMap> getCdList_1(Map<String, Object> params);

  List<EgovMap> selectHsManualListPop(Map<String, Object> params);

  EgovMap selectHSResultMList(Map<String, Object> params);

  void insertHsResult(Map<String, Object> params);

  void updateHsScheduleM(Map<String, Object> params);

  int getNextSchdulId();

  int getNextSvc006dSeq();

  EgovMap selectHsInitDetailPop(Map<String, Object> params);

  void insertHsResultfinal(Map<String, Object> params);

  void insertHsResultCopy(Map<String, Object> params);

  List<EgovMap> cmbCollectTypeComboList();

  List<EgovMap> cmbCollectTypeComboList2();

  void updateDocNo(Map<String, Object> params);

  EgovMap selectHSDocNoList(Map<String, Object> params);

  int selectHSResultMCnt(Map<String, Object> params);

  int selectHSScheduleMCnt(Map<String, Object> params);

  List<EgovMap> selectHsFilterList(Map<String, Object> params);

  List<EgovMap> cmbServiceMemList();

  EgovMap selectSrvConfiguration(Map<String, Object> params);

  EgovMap selectDetailList(Map<String, Object> params);

  void insertHsResultD(Map<String, Object> params);

  EgovMap selectHsViewBasicInfo(Map<String, Object> params);

  void updateHsSrvConfigM(EgovMap params);

  List<EgovMap> failReasonList(Map<String, Object> params);

  List<EgovMap> serMemList(Map<String, Object> params);

  List<EgovMap> selectHsViewfilterInfo(Map<String, Object> params);

  EgovMap selectSettleInfo(Map<String, Object> params);

  void updateHsResultM(EgovMap params);

  void updateHsResultD(Map<String, Object> params);

  List<EgovMap> selectFilterTransaction(Map<String, Object> params);

  List<EgovMap> selectHistoryHSResult(Map<String, Object> params);

  EgovMap selectConfigBasicInfo(Map<String, Object> params);

  int updateHsConfigBasic(Map<String, Object> params);

  void insertHsConfigSetting(LinkedHashMap hsBasicmap);

  EgovMap selectConfigBasicInfoYn(Map<String, Object> params);

  List<EgovMap> selectConfigSettingYn(Map<String, Object> params);

  void updateHsconfigSetting(Map<String, Object> sal0089);

  EgovMap selectHSOrderView(Map<String, Object> params);

  List<EgovMap> selectOrderInactiveFilter(Map<String, Object> params);

  List<EgovMap> selectOrderActiveFilter(Map<String, Object> params);

  void updateAssignCody(Map<String, Object> updateMap);

  void updateAssignCody90D(Map<String, Object> updateMap);

  void updateHsSVC0006D(Map<String, Object> sal0090);

  void updateHsFilterSiriNo(Map<String, Object> docSub);

  void updateHsFilterSiriNo2(Map<String, Object> docSub);

  String select0087DFilter(Map<String, Object> docSub);

  String select0087DFilter2(Map<String, Object> docSub);

  void updateHs009d(Map<String, Object> params);

  List<EgovMap> selectBranch_id(Map<String, Object> params);

  List<EgovMap> selectCTMByDSC_id(Map<String, Object> params);

  EgovMap selectCheckMemCode(Map<String, Object> params);

  EgovMap selectSerMember(Map<String, Object> params);

  public List<EgovMap> selectHSCodyList(Map<String, Object> params);

  String selectMemberId(Map<String, Object> params);

  void updateSrvCodyId(Map<String, Object> params);

  void insertCcr0001d(Map<String, Object> callMas);

  List<EgovMap> selectHSAddFilterSetInfo(Map<String, Object> params);

  List<EgovMap> addSrvFilterIdCnt(Map<String, Object> params);

  int updateFilterInfo(Map<String, Object> params);

  String getSrvConfigId_SAL009(Map<String, Object> params);

  String getbomPartPriod_LOG0001M(Map<String, Object> params);

  String getSalesDtSAL_0001D(Map<String, Object> params);

  EgovMap getSrvConfigFilter_SAL0087D(Map<String, Object> params);

  void saveChanges(Map<String, Object> send_sal0087D);

  void saveHsFilterInfoAdd(Map<String, Object> params);

  int saveDeactivateFilter(Map<String, Object> params);

  int saveFilterUpdate(Map<String, Object> params);

  List<EgovMap> selecthSFilterUseHistorycall(Map<String, Object> params);

  String getSVC008D_NO(Map<String, Object> params);

  void updateHsResultM2(EgovMap params);

  String GetDocNo(Map<String, Object> params);

  int GetDocNo1(Map<String, Object> params);

  EgovMap selectQryBS_Rev(Map<String, Object> params);

  void addbsResultMas_Rev(Map<String, Object> params);

  List<EgovMap> selectQryResultDet(Map<String, Object> params);

  EgovMap selectQry_stkReqM(Map<String, Object> params);

  int getBSResultM_resultID();

  void addbsResultDet_Rev(Map<String, Object> params);

  void addstkReqM_Rev(Map<String, Object> params);

  int getMobileWarehouseByMemID(Map<String, Object> params);

  EgovMap selectQryBS(Map<String, Object> params);

  EgovMap qry_stkReqD_Rev(Map<String, Object> params);

  int getStkReqM_StkReqID();

  void addStkReqD_Rev(Map<String, Object> params);

  void addStkCrd_Rev(Map<String, Object> params);

  void updateQry_CurBS(Map<String, Object> params);

  void updateQry_New(Map<String, Object> params);

  void addbsResultMas(Map<String, Object> params);

  void updatebsResultMas(Map<String, Object> params);

  void updateQrySchedule(Map<String, Object> params);

  void updateQryConfig(Map<String, Object> params);

  void updateQryConfig4(Map<String, Object> params);

  int selectLocationID(Map<String, Object> params);

  EgovMap selectQrySchedule(Map<String, Object> params);

  void addStkCrd_new(Map<String, Object> params);

  EgovMap selectQryConfig(Map<String, Object> params);

  void updateQryFilter(Map<String, Object> params);

  void updateQryFilter_rev(Map<String, Object> params);

  void updateIsReturn(Map<String, Object> params);

  void addBsResultDet_NoFilter(Map<String, Object> params);

  // add by hgham mobile 중복 처리
  int isHsAlreadyResult(Map<String, Object> params);

  void updateQry_CurBSZero(Map<String, Object> qry_CurBS);

  EgovMap selectResultId(Map<String, Object> qry_CurBS);

  // Add HS Result - Save Validation
  int saveValidation(Map<String, Object> params);

  EgovMap selectHsOrderInMonth(Map<String, Object> params);

  List<EgovMap> hSMgtResultViewResultFilter(Map<String, Object> params);

  EgovMap hSMgtResultViewResult(Map<String, Object> params);

  List<EgovMap> assignDeptMemUp(Map<String, Object> params);

  List<EgovMap> selectCMList(Map<String, Object> params);

  int hsResultSync(Map<String, Object> params);

  void updateInstRemark(Map<String, Object> bsResultInst);

  // OMBAK - AS ENTRY RESULT & INVOICE BILLING -- TPY

  String saveASEntry(Map<String, Object> params);

  EgovMap getASEntryDocNo(Map<String, Object> params);

  EgovMap getASEntryId(Map<String, Object> params);

  int insertSVC0001D(Map<String, Object> params);

  int insertSVC0003D(Map<String, Object> params);

  void updateStateSVC0001D(Map<String, Object> params);

  int insertSVC0004D(Map<String, Object> params);

  EgovMap getResultASEntryId(Map<String, Object> params2);

  int insertSVC0005D(Map<String, Object> params3);

  EgovMap getBSFilterInfo(Map<String, Object> params);

  EgovMap selectBasicInfo(Map<String, Object> params);

  EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params);

  EgovMap selectTaxInvoice(Map<String, Object> params);

  int insert_Pay0031d(Map<String, Object> param);

  int getSeqPay0031D();

  void insert_Pay0032d(Map<String, Object> param);

  void insert_Pay0016d(Map<String, Object> param);

  void insert_Pay0006d(Map<String, Object> param4);

  void insert_Pay0007d(Map<String, Object> param5);

  EgovMap checkStkDuration(Map<String, Object> params);

  List<EgovMap> selectQryUsedFilter(Map<String, Object> params);

  List<EgovMap> selectQryUsedFilter2(Map<String, Object> params);

  void addusedFilter_Rev(Map<String, Object> params);

  void addusedFilter(Map<String, Object> params);

  int selectTotalFilter(Map<String, Object> params);

  List<EgovMap> selectQryUsedFilterNew(Map<String, Object> params);

  int selectCustomer(Map<String, Object> params);

  String selectSerialNo(Map<String, Object> params);

  int selectCody(Map<String, Object> params);

  void insertUsedFilter(Map<String, Object> params);

  //HS REVERSE OMBAK -- ADDED BY TPY - 18/06/2019

  EgovMap checkHsBillASInfo(Map<String, Object> params);

  int checkDuplicateReverse(Map<String, Object> p);

  EgovMap checkHsBillASInfoPass(Map<String, Object> params);

  void updateHsResultMas(Map<String, Object> params);

  void updateIsCurrent_SVC0004D(Map<String, Object> params);

  // CREATE HS ORDER POP UP NOTIFICATION -- TPY 24/06/2019

  EgovMap checkWarrentyStatus(Map<String, Object> params);

  EgovMap checkSvcMembershipInfo(Map<String, Object> params);

  EgovMap checkRentalStatusInfo(Map<String, Object> params);

  EgovMap checkOrderStatusInfo(Map<String, Object> params);

  List<EgovMap> getAppTypeList(Map<String, Object> params);

  void updateDisinfecSrv(Map<String, Object> params);

  List<EgovMap> instChkLst();

  EgovMap getHsResultDocNo(Map<String, Object> params);

  void editHSEditSettleDate(Map<String, Object> params);

  int selectFilterSerial(Map<String, Object> params);

  void updateHsFilterSerial(Map<String, Object> params);

  //CELESTE : 25/08/2022 : EDIT CUSTOMER INFO[S]
  EgovMap selectBrchDt(Map<String, Object> params);
  EgovMap selectOldContactDt(Map<String, Object> params);
  void insertSAL0329D(Map<String, Object> params);
  //CELESTE : 25/08/2022 : EDIT CUSTOMER INFO[E]

  int getSrvTypeChgTm(Map<String, Object> params);

  EgovMap getPromoItemInfo(Map<String, Object> params);

  List<EgovMap> getOderOutsInfo(Map<String, Object> params);

  void insertHsConfigBasicHistory(Map<String, Object> params);

  List<EgovMap> getSrvTypeChgHistoryLogInfo(Map<String, Object> params);

  EgovMap getSSGstRebate(Map<String, Object> params);

  void updateSSRebateStatus(Map<String, Object> params);

  EgovMap getPvSSRebate(Map<String, Object> params);

  void updatePvSSRebateStatus(Map<String, Object> params);

  void insertPvSSRebate(Map<String, Object> params);

  void updateHsConfigBasicHistoryStatus(Map<String, Object> params);

  EgovMap getSrvTypeChgInfo(Map<String, Object> params);
}
