package com.coway.trust.biz.services.as.impl;

	import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyDto;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.biz.sales.mambership.impl.MembershipRentalQuotationMapper;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *
 * 01/04/2019 	 ONGHC 			1.0.1				- Restructure File
 * 08/05/2019 	 ONGHC 			1.0.2 			- Amend asResult_insert
 * 23/05/2019 	 ONGHC 			1.0.3 			- Amend asResult_insert
 * 26/07/2019 	 ONGHC 			1.0.4 			- Add Recall Status
 * 26/07/2019 	 ONGHC 			1.0.5 			- Remove In House SMO
 * 05/09/2019 	 ONGHC 			1.0.6 			- Create saveASEntryInHouse
 * 05/09/2019 	 ONGHC 			1.0.7 			- Amend In House Call Log Result
 * 17/09/2019 	 ONGHC 			1.0.8 			- Create getDftTyp
 * 08/10/2019 	 ONGHC 			1.0.9 			- Amend asResultBasic_update
 * 21/10/2019 	 ONGHC 			1.0.10 			- Amend chkPmtMap and Un-map Payment Function
 * 17/12/2019 	 ONGHC 			1.0.11 			- Add AS Used Filter Feature
 * 05/10/2020 	 FARUQ 			1.0.12 			- -Add getAsDefectEntry
 *********************************************************************************************/

@Service("ASManagementListService")
public class ASManagementListServiceImpl extends EgovAbstractServiceImpl implements ASManagementListService {

  private static final Logger LOGGER = LoggerFactory.getLogger(ASManagementListServiceImpl.class);

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "ASManagementListMapper")
  private ASManagementListMapper ASManagementListMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "membershipRentalQuotationMapper")
  private MembershipRentalQuotationMapper membershipRentalQuotationMapper;

  @Resource(name = "posMapper")
  private PosMapper posMapper;

  @Resource(name = "asFromCodyApiServiceMapper")
  private AsFromCodyApiServiceMapper asFromCodyApiServiceMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "installationResultListMapper")
  private InstallationResultListMapper installationResultListMapper;



  @Override
  public List<EgovMap> selectASManagementList(Map<String, Object> params) {
    return ASManagementListMapper.selectASManagementList(params);
  }

  @Override
  public List<EgovMap> getAsDefectEntry(Map<String, Object> params) {
    return ASManagementListMapper.getAsDefectEntry(params);
  }

  @Override
  public List<EgovMap> getASHistoryList(Map<String, Object> params) {
    return ASManagementListMapper.getASHistoryList(params);
  }

  @Override
  public List<EgovMap> getASStockPrice(Map<String, Object> params) {
    return ASManagementListMapper.getASStockPrice(params);
  }

  @Override
  public List<EgovMap> getASFilterInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASFilterInfo(params);
  }

  @Override
  public List<EgovMap> getASFilterInfoOld(Map<String, Object> params) {
    return ASManagementListMapper.getASFilterInfoOld(params);
  }

  @Override
  public List<EgovMap> getASReasonCode(Map<String, Object> params) {
    return ASManagementListMapper.getASReasonCode(params);
  }

  @Override
  public List<EgovMap> getASMember(Map<String, Object> params) {
    return ASManagementListMapper.getASMember(params);
  }

  @Override
  public List<EgovMap> getASReasonCode2(Map<String, Object> params) {
    return ASManagementListMapper.getASReasonCode2(params);
  }

  @Override
  public List<EgovMap> getBSHistoryList(Map<String, Object> params) {
    return ASManagementListMapper.getBSHistoryList(params);
  }

  @Override
  public List<EgovMap> getBrnchId(Map<String, Object> params) {
    return ASManagementListMapper.getBrnchId(params);
  }

  @Override
  public List<EgovMap> getCallLog(Map<String, Object> params) {
    return ASManagementListMapper.getCallLog(params);
  }

  @Override
  public List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASRulstEditFilterInfo(params);
  }

  @Override
  public EgovMap spFilterClaimCheck(Map<String, Object> params) {
    return ASManagementListMapper.spFilterClaimCheck(params);
  }

  @Override
  public EgovMap getStockPricebyStkID(Map<String, Object> params) {
    return ASManagementListMapper.selectStkPriceByStkID(params);
  }

  @Override
  public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASRulstSVC0004DInfo(params);
  }

  @Override
  public List<EgovMap> getErrMstList(Map<String, Object> params) {
    return ASManagementListMapper.getErrMstList(params);
  }

  @Override
  public List<EgovMap> getErrDetilList(Map<String, Object> params) {
    return ASManagementListMapper.getErrDetilList(params);
  }

  @Override
  public List<EgovMap> getSLUTN_CODE_List(Map<String, Object> params) {
    return ASManagementListMapper.getSLUTN_CODE_List(params);
  }

  @Override
  public List<EgovMap> getDTAIL_DEFECT_List(Map<String, Object> params) {
    return ASManagementListMapper.getDTAIL_DEFECT_List(params);
  }

  @Override
  public List<EgovMap> getDEFECT_PART_List(Map<String, Object> params) {
    return ASManagementListMapper.getDEFECT_PART_List(params);
  }

  @Override
  public List<EgovMap> getDEFECT_CODE_List(Map<String, Object> params) {
    return ASManagementListMapper.getDEFECT_CODE_List(params);
  }

  @Override
  public List<EgovMap> getDEFECT_TYPE_List(Map<String, Object> params) {
    return ASManagementListMapper.getDEFECT_TYPE_List(params);
  }

  @Override
  public List<EgovMap> selectASDataInfo(Map<String, Object> params) {
    return ASManagementListMapper.selectASDataInfo(params);
  }

  @Override
  public List<EgovMap> assignCtList(Map<String, Object> params) {
    return ASManagementListMapper.assignCtList(params);
  }

  @Override
  public List<EgovMap> assignCtOrderList(Map<String, Object> params) {
    return ASManagementListMapper.assignCtOrderList(params);
  }

  @Override
  public EgovMap getMemberBymemberID(Map<String, Object> params) {
    return ASManagementListMapper.getMemberBymemberID(params);
  }

  @Override
  public EgovMap selectOrderBasicInfo(Map<String, Object> params) {
    return ASManagementListMapper.selectOrderBasicInfo(params);
  }

  @Override
  public EgovMap getASEntryDocNo(Map<String, Object> params) {
    return ASManagementListMapper.getASEntryDocNo(params);
  }

  @Override
  public EgovMap getASEntryId(Map<String, Object> params) {
    return ASManagementListMapper.getASEntryId(params);
  }

  @Override
  public EgovMap getResultASEntryId(Map<String, Object> params) {
    return ASManagementListMapper.getResultASEntryId(params);
  }

  @Override
  public int isAsAlreadyResult(Map<String, Object> params) {
    return ASManagementListMapper.isAsAlreadyResult(params);
  }

  @Override
  public int asResultSync(Map<String, Object> params) {
    return ASManagementListMapper.asResultSync(params);
  }

  @Override
  public String getCustAddressInfo(Map<String, Object> params) {
    return ASManagementListMapper.getCustAddressInfo(params);
  }

  @Override
  public EgovMap getSmsCTMemberById(Map<String, Object> params) {
    return ASManagementListMapper.getSmsCTMemberById(params);
  }

  @Override
  public EgovMap getSmsCTMMemberById(Map<String, Object> params) {
    return ASManagementListMapper.getSmsCTMMemberById(params);
  }

  @Override
  public EgovMap getMemberByMemberIdCode(Map<String, Object> params) {
    return ASManagementListMapper.getMemberByMemberIdCode(params);
  }

  @Override
  public int addASRemark(Map<String, Object> params) {
    int result = -1;
    result = ASManagementListMapper.insertAddCCR0007D(params);

    if (result > 0) {
      ASManagementListMapper.updateCCR0006D(params);
    }

    return result;
  }

  @Override
  public int updateAssignCT(Map<String, Object> params) {
    List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    int rtnValue = -1;

    if (updateItemList.size() > 0) {

      for (int i = 0; i < updateItemList.size(); i++) {
        Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
        rtnValue = ASManagementListMapper.updateAssignCT(updateMap);
      }
    }
    return rtnValue;
  }

  @Override
  public boolean insertOptFlt(Map<String, Object> params) {
    LOGGER.debug(" ============= START INSERT MINERAL RECORD ============= ");
    Map mp = (Map) params.get("asResultM");
    if (mp.get("AS_RESULT_STUS_ID").equals("4")) { // IF AS STATUS = COMPLETE

      List<EgovMap> fltConfLst = (List<EgovMap>) getfltConfLst();
      List<EgovMap> addListing = (List<EgovMap>) params.get("add");
      List<EgovMap> removeListing = (List<EgovMap>) params.get("removeList");
      boolean fltSta = false;

      LOGGER.debug(" ============= OPTIONAL FILTER NUMBER:: " + fltConfLst.size());
      for (int a = 0; a < fltConfLst.size(); a++) {
        Map<String, Object> fltConfLstMap = (Map<String, Object>) fltConfLst.get(a);
        LOGGER.debug(" ============= FILTER :: " + fltConfLstMap.get("stkId") + " " + fltConfLstMap.get("stkDesc"));
        for (int i = 0; i < addListing.size(); i++) {
          LOGGER.debug(" ============= :: " + i);
          if (addListing.get(i) != null) {
            Map<String, Object> updateMap = (Map<String, Object>) addListing.get(i);
            LOGGER.debug(" ============= :: " + CommonUtils.nvl(updateMap.get("filterID")).toString() + " = "
                + CommonUtils.nvl(fltConfLstMap.get("stkId")).toString());
            if ((CommonUtils.nvl(updateMap.get("filterID")).toString())
                .equals((CommonUtils.nvl(fltConfLstMap.get("stkId"))).toString())) {
              fltSta = true;
              break;
            } else {
              fltSta = false;
            }
          }
        }

        if (fltSta) {
          // CHECK SAL0087D RECORD EXIST
          HashMap hm = new HashMap();
          hm.put("ordNo", (String) mp.get("AS_ORD_NO"));
          hm.put("cond1", fltConfLstMap.get("stkId"));

          int noOfMineralFilter = getFilterCount(hm);
          LOGGER.debug(" ============= NO OF MINERAL :: " + noOfMineralFilter);
          if (noOfMineralFilter == 0) {
            // MINERAL FILTER EXIST , TRY TO GET CONFIG ID
            hm.put("cond1", "");
            int noOfFilter = getFilterCount(hm);

            LOGGER.debug(" ============= NO OF MINERAL :: " + noOfFilter);
            if (noOfFilter > 0) {
              // GET EXISTING CONFIG ID AND INSERT WITH MINERAL WITH THIS CONFIG
              // ID
              mp.put("configId", getSAL87ConfigId((String) mp.get("AS_ORD_NO")));
            } else {
              // INSERT SAL0087D WITH CONFIG ID = 0. THIS VALUE WILL BE UPDATED
              // LATER
              mp.put("configId", "0");
            }
            mp.put("fID", fltConfLstMap.get("stkId"));
            mp.put("status", "1");
            insert_SAL0087D(mp);
          }
        } else {
          LOGGER.debug(" ============= NO FILTER MATCHED TO PROCESS =============");
        }

        for (int i = 0; i < addListing.size(); i++) {
            LOGGER.debug(" ============= :: " + i);
            if (addListing.get(i) != null) {
            	Map<String, Object> updateMap = (Map<String, Object>) addListing.get(i);
            	LOGGER.debug(" ============= :: " + CommonUtils.nvl(updateMap.get("filterCode")).toString() + " = " + CommonUtils.nvl(fltConfLstMap.get("stkId")).toString());
            	LOGGER.debug("addListing ======" + addListing);
            	LOGGER.debug("updateMap ======" + updateMap);


            	if (CommonUtils.nvl(updateMap.get("filterCode")).toString().equals("113794")) { //FOR PRE-FILTER
            		mp.put("configId", getSAL87ConfigId((String) mp.get("AS_ORD_NO")));

            		EgovMap param = new EgovMap();
            		param.put("itmcode", "3118441");
            		EgovMap entry2 = ASManagementListMapper.selectStkCatType(param);
            		mp.put("fID", entry2.get("stkid"));

            		int prefilCount = ASManagementListMapper.selectExistingPreFilterCount(mp);
            		if(prefilCount > 0){
            			EgovMap preFilterInfo = ASManagementListMapper.selectExistingPreFilterInfo(mp);

            			if(CommonUtils.nvl(preFilterInfo.get("srvFilterStusId")).toString().equals("8")){
            				mp.put("status", "1"); //add new filter = update filter status in SAL0087D to active when exists, else insert 1 new row
            				mp.put("userId", params.get("updator"));
            				updateStatus_SAL0087D(mp);
            			}else if(CommonUtils.nvl(preFilterInfo.get("srvFilterStusId")).toString().equals("1")){
            				mp.put("status", "8"); //add new filter = update filter status in SAL0087D to active when exists, else insert 1 new row
            				mp.put("userId", params.get("updator"));
            				updateStatus_SAL0087D(mp);
            			}

            		}
            		else{
            			mp.put("status", "1"); //add new filter = update filter status in SAL0087D to active when exists, else insert 1 new row
                		insert_SAL0087D(mp);
            		}
            	}
            }
        }

        LOGGER.debug(" ============= REMOVE FILTER DURING EDIT ASR =============");

        for(int i = 0; i < removeListing.size(); i++){
        	LOGGER.debug(" ============= :: " + i);
        	if(removeListing.get(i) != null){
        		Map<String, Object> deleteMap = (Map<String, Object>) removeListing.get(i);
        		if (CommonUtils.nvl(deleteMap.get("stkCode")).toString().equals("113794")) { //FOR PRE-FILTER
        			mp.put("configId", getSAL87ConfigId((String) mp.get("AS_ORD_NO")));

        			EgovMap param1 = new EgovMap();
        			param1.put("itmcode", "3118441");
            		EgovMap entry2 = ASManagementListMapper.selectStkCatType(param1);
            		mp.put("fID", entry2.get("stkid"));
            		mp.put("userId", params.get("updator"));
            		mp.put("status", "8"); //remove filter = update filter status in SAL0087D to inactive
            		updateStatus_SAL0087D(mp);
        		}
        	}
        }

      }
    }
    LOGGER.debug(" ============= END INSERT MINERAL RECORD ============= ");
    return true;
  }

  @Override
  public int getFilterCount(Map<String, Object> params) {
    return ASManagementListMapper.getFilterCount(params);
  }

  @Override
  public List<EgovMap> getfltConfLst() {
    return ASManagementListMapper.getfltConfLst();
  }

  @Override
  public int getSAL87ConfigId(String params) {
    return ASManagementListMapper.getSAL87ConfigId(params);
  }

  @Override
  public int insert_SAL0087D(Map<String, Object> params) {
    return ASManagementListMapper.insert_SAL0087D(params);
  }

  @Override
  public int updateStatus_SAL0087D(Map<String, Object> params) {
	  return ASManagementListMapper.updateStatus_SAL0087D(params);
  }

  @Override
  public EgovMap saveASEntry(Map<String, Object> params) {

    String AS_NO = "";
    String ARS_AS_ID = "";

    if ("RAS".equals(params.get("ISRAS"))) {
      // ARS인경우에는 AS_ID가 존재함.
      ARS_AS_ID = (String) params.get("AS_ID");
      params.put("REF_REQUEST", ARS_AS_ID);
    }

    params.put("DOCNO", "17");
    EgovMap eMap = ASManagementListMapper.getASEntryDocNo(params);

    EgovMap seqMap = ASManagementListMapper.getASEntryId(params);
    EgovMap ccrSeqMap = ASManagementListMapper.getCCR0006D_CALL_ENTRY_ID_SEQ(params);

    params.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    params.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    params.put("AS_CALLLOG_ID", String.valueOf(ccrSeqMap.get("seq")).trim());

    // 서비스 마스터
    int a = ASManagementListMapper.insertSVC0001D(params);
    int b = 0;

    // 콜로그생성
    int c6d = ASManagementListMapper.insertCCR0006D(setCCR000Data(params));
    int c7d = ASManagementListMapper.insertCCR0007D(setCCR000Data(params));

    String PIC_NAME = String.valueOf(params.get("PIC_NAME"));
    String PIC_CNTC = String.valueOf(params.get("PIC_CNTC"));

    if (PIC_NAME.length() > 0 || PIC_CNTC.length() > 0) {
      b = ASManagementListMapper.insertSVC0003D(params);
    }

    // RAS 상태 업데이트
    if ("RAS".equals(params.get("ISRAS"))) {
      HashMap<Object, String> rasMap = new HashMap<Object, String>();
      rasMap.put("AS_ENTRY_ID", ARS_AS_ID);
      rasMap.put("USER_ID", String.valueOf(params.get("updator")));
      rasMap.put("AS_RESULT_STUS_ID", "4");
      ASManagementListMapper.updateStateSVC0001D(params);
    }

    /*
     * //물류 호출 /////////////////////////물류 호출////////////////////// Map<String, Object> logPram = new HashMap<String, Object>(); logPram.put("ORD_ID", String.valueOf( eMap.get("asno")).trim()); logPram.put("RETYPE", "SVO"); logPram.put("P_TYPE", "OD01"); logPram.put("P_PRGNM", "ASACT"); logPram.put("USERID", Integer.parseInt(String.valueOf(params.get("USER_ID"))));
     *
     * Map SRMap=new HashMap();
     *
     * LOGGER.debug("ASManagementListServiceImpl.saveASEntry 물류 호출 PRAM ===>"+ logPram.toString()); servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram); LOGGER.debug( "ASManagementListServiceImpl.saveASEntry 물류 호출 결과 ===>" +logPram.toString()); logPram.put("P_RESULT_TYPE", "AS"); logPram.put("P_RESULT_MSG", logPram.get("p1")); /////////////////////////물류 호출 END //////////////////////
     */

    LOGGER.debug(" ============= PREASTYPE :: " + params);

    if ("PREAS".equals(params.get("PREASTYPE"))) {

    	  ASManagementListMapper.updateSVC0130D(params);
      }



    EgovMap em = new EgovMap();

    em.put("AS_NO", String.valueOf(params.get("AS_NO")));
    em.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());

    LOGGER.debug("===================================");
    LOGGER.debug(em.toString());
    LOGGER.debug("===================================");
    return em;
  }

  @Override
  public EgovMap saveASInHouseEntry(Map<String, Object> params) {

    Map svc0004dmap = (Map) params.get("asResultM");// hash

    String AS_NO = "";

    params.put("DOCNO", "17");
    EgovMap eMap = ASManagementListMapper.getASEntryDocNo(params);
    EgovMap seqMap = ASManagementListMapper.getASEntryId(params);

    AS_NO = String.valueOf(eMap.get("asno")).trim();

    params.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    params.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    svc0004dmap.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    svc0004dmap.put("AS_NO", String.valueOf(eMap.get("asno")).trim());

    params.put("DOCNO", "21");
    EgovMap eMap_result = ASManagementListMapper.getASEntryDocNo(params);
    EgovMap seqMap_result = ASManagementListMapper.getResultASEntryId(params);
    String AS_RESULT_ID = String.valueOf(seqMap_result.get("seq"));
    String AS_RESULT_NO = String.valueOf(eMap_result.get("asno"));

    EgovMap ccrSeqMap = ASManagementListMapper.getCCR0006D_CALL_ENTRY_ID_SEQ(params);
    params.put("AS_CALLLOG_ID", String.valueOf(ccrSeqMap.get("seq")).trim());
    svc0004dmap.put("AS_CALLLOG_ID", String.valueOf(ccrSeqMap.get("seq")).trim());

    // 서비스 마스터
    int a = ASManagementListMapper.insertSVC0001D(svc0004dmap);

    // 콜로그생성
    int c6d = ASManagementListMapper.insertCCR0006D(setCCR000Data(svc0004dmap));
    int c7d = ASManagementListMapper.insertCCR0007D(setCCR000Data(svc0004dmap));

    String PIC_NAME = String.valueOf(svc0004dmap.get("PIC_NAME"));
    String PIC_CNTC = String.valueOf(svc0004dmap.get("PIC_CNTC"));

    int b = -1;
    if (PIC_NAME.length() > 0 || PIC_CNTC.length() > 0) {
      b = ASManagementListMapper.insertSVC0003D(svc0004dmap);
    }

    svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
    svc0004dmap.put("AS_RESULT_NO", AS_RESULT_NO);
    svc0004dmap.put("AS_ENTRY_ID", String.valueOf(seqMap.get("seq")).trim());
    svc0004dmap.put("updator", params.get("updator"));

    /// insert svc0004d
    int c = this.insertInHouseSVC0004D(svc0004dmap);
    int callint = updateSTATE_CCR0006D(svc0004dmap);

    List<EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
    this.insertSVC0005D(addItemList, AS_RESULT_ID, String.valueOf(params.get("updator")));

    ///////////////////////// 물류 호출//////////////////////
    Map<String, Object> logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", String.valueOf(eMap.get("asno")).trim());
    logPram.put("RETYPE", "COMPLET");
    logPram.put("P_TYPE", "OD03");
    logPram.put("P_PRGNM", "ASCOM_IN2");
    logPram.put("USERID", String.valueOf(params.get("updator")));

    Map SRMap = new HashMap();
    LOGGER.debug("ASManagementListServiceImpl.asResult_insert  물류 차감  PRAM ===>" + logPram.toString());
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
    LOGGER.debug("ASManagementListServiceImpl.asResult_insert  물류 차감   결과 ===>" + logPram.toString());
    logPram.put("P_RESULT_TYPE", "AS");
    logPram.put("P_RESULT_MSG", logPram.get("p1"));
    ///////////////////////// 물류 호출 END //////////////////////

    EgovMap em = new EgovMap();
    em.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    em.put("AS_RESULT_NO", AS_RESULT_NO);
    em.put("SP_MAP", logPram);

    return em;
  }

  @Override
  public EgovMap updateASInHouseEntry(Map<String, Object> params) {

    EgovMap em = new EgovMap();

    Map svc0004dmap = (Map) params.get("asResultM");// hash
    svc0004dmap.put("updator", params.get("updator"));

    int update_svcCnt = ASManagementListMapper.updateInHouseSVC0004D(svc0004dmap);
    int appdtcnt = ASManagementListMapper.updateInhouseSVC0001D_appdt(svc0004dmap);

    List<EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
    List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    List<EgovMap> removeItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_REMOVE);

    LOGGER.debug("====params=======>" + params.toString());
    LOGGER.debug("====svc0004dmap=======>" + svc0004dmap.toString());
    LOGGER.debug("====addItemList=======>" + addItemList.toString());
    LOGGER.debug("====removeItemList=======>" + removeItemList.toString());
    LOGGER.debug("====updateItemList=======>" + updateItemList.toString());

    if (addItemList.size() > 0) {
      this.insertSVC0005D(addItemList, String.valueOf(svc0004dmap.get("AS_RESULT_ID")),
          String.valueOf(params.get("updator")));
    }

    // UPDATE
    if (updateItemList.size() > 0) {
      for (int i = 0; i < updateItemList.size(); i++) {

        Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
        Map<String, Object> iMap = new HashMap();

        if (!"".equals(updateMap.get("filterDesc"))) {
          String temp = (String) updateMap.get("filterDesc");
          if (null != temp) {
            if (!temp.equals("API")) {
              String[] animals = temp.split("-");
              if (animals.length > 0) {
                iMap.put("ASR_ITM_PART_DESC", animals[1]);
              } else {
                iMap.put("ASR_ITM_PART_DESC", "");
              }
            }
          }
        }

        iMap.put("ASR_ITM_ID", updateMap.get("filterId"));

        iMap.put("ASR_ITM_PART_QTY", updateMap.get("filterQty"));
        iMap.put("ASR_ITM_PART_PRC", updateMap.get("filterPrice"));
        iMap.put("ASR_ITM_CHRG_AMT", updateMap.get("filterTotal"));
        iMap.put("ASR_ITM_REM", updateMap.get("filterRemark"));
        iMap.put("ASR_ITM_CRT_USER_ID", String.valueOf(params.get("updator")));

        if (updateMap.get("filterType").equals("FOC")) {
          iMap.put("ASR_ITM_CHRG_FOC", "1");
        } else {
          iMap.put("ASR_ITM_CHRG_FOC", "0");
        }

        iMap.put("ASR_ITM_EXCHG_ID", updateMap.get("filterExCode"));
        iMap.put("ASR_ITM_CLM", "0");
        iMap.put("ASR_ITM_TAX_CODE_ID", "0");
        iMap.put("ASR_ITM_TXS_AMT", "0");

        iMap.put("SERIAL_NO", updateMap.get("srvFilterLastSerial"));
        iMap.put("FILTER_BARCD_SERIAL_NO", updateMap.get("srvFilterLastSerial"));
        iMap.put("EXCHG_ID", updateMap.get("filterExCode"));

        LOGGER.debug("                  UPDATESVC0005D {} ", iMap);
        ASManagementListMapper.updateInhouseSVC0005D(iMap);
      }

    }

    // delete
    if (removeItemList.size() > 0) {
      for (int i = 0; i < removeItemList.size(); i++) {
        Map<String, Object> updateMap = (Map<String, Object>) removeItemList.get(i);
        Map<String, Object> iMap = new HashMap();

        iMap.put("ASR_ITM_ID", updateMap.get("filterId"));

        LOGGER.debug("                  delete SVC0005D {} ", iMap);
        ASManagementListMapper.deleteInhouseSVC0005D(iMap);
      }
    }

    return em;
  }

  @Override
  public Map<String, Object> setCCR000Data(Map<String, Object> params) {

    Map<String, Object> em = new HashMap<String, Object>();

    em.put("CALL_ENTRY_ID", params.get("AS_CALLLOG_ID"));
    em.put("SALES_ORD_ID", params.get("AS_SO_ID"));
    em.put("TYPE_ID", "339");
    em.put("STUS_CODE_ID", "40");
    em.put("RESULT_ID", "0");
    em.put("DOC_ID", params.get("AS_ID"));
    em.put("USER_ID", params.get("USER_ID"));
    em.put("IS_WAIT_FOR_CANCL", "0");
    em.put("HAPY_CALLER_ID", "0");

    em.put("CALL_ENTRY_ID", params.get("AS_CALLLOG_ID"));
    em.put("CALL_STUS_ID", "40");
    em.put("CALL_FDBCK_ID", "0");
    em.put("CALL_REM", params.get("CALL_REM"));
    em.put("CALL_HC_ID", "0");
    em.put("CALL_ROS_AMT", "0");
    em.put("CALL_SMS", "0");
    em.put("CALL_SMS_REM", "");

    LOGGER.debug("== PARAMS " + em.toString());
    return em;
  }

  @Override
  public EgovMap updateASEntry(Map<String, Object> params) {

    String m = "";
    int a = ASManagementListMapper.updateSVC0001D(params);

    String PIC_NAME = String.valueOf(params.get("PIC_NAME"));
    String PIC_CNTC = String.valueOf(params.get("PIC_CNTC"));

    // if(PIC_NAME.length() > 0 || PIC_CNTC.length() > 0 ){
    ASManagementListMapper.updateSVC0003D(params);
    // }

    // 물류 호출
    if (a > 0)
      m = "goodjob";

    EgovMap em = new EgovMap();
    em.put("result", m);

    return em;
  }

  @Override
  public EgovMap selASEntryView(Map<String, Object> params) {
    return ASManagementListMapper.selASEntryView(params);
  }

  @Override
  public boolean insertASNo(Map<String, Object> params, SessionVO sessionVO) {

    return false;
  }

  @Override
  public List<EgovMap> getASOrderInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASOrderInfo(params);
  }

  @Override
  public List<EgovMap> getASRclInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASRclInfo(params);
  }

  @Override
  public List<EgovMap> getASEvntsInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASEvntsInfo(params);
  }

  @Override
  public List<EgovMap> getASHistoryInfo(Map<String, Object> params) {
    return ASManagementListMapper.getASHistoryInfo(params);
  }

  /**
   * /svc0001d 상태 업데이트
   *
   * @param params
   * @return
   */
  public int updateStateSVC0001D(Map<String, Object> params) {
    int b = ASManagementListMapper.updateStateSVC0001D(params);
    return b;
  }

  /**
   * /svc0001d 상태 업데이트
   *
   * @param params
   * @return
   */
  public int updateState_SERIAL_NO_SVC0004D(Map<String, Object> params) {
    // svc0001d 상태 업데이트
    int b = ASManagementListMapper.updateState_SERIAL_NO_SVC0004D(params);
    return b;
  }

  /**
   * SVC0004D insert
   *
   * @param params
   * @return
   */
  public int insertSVC0004D(Map<String, Object> params) {
    LOGGER.debug("== insertSVC0004D - START");
    LOGGER.debug("== PARAMS {} ", params);

    int a = ASManagementListMapper.insertSVC0004D(params);

    LOGGER.debug("== insertSVC0004D - END");

    return a;
  }

  public int updateSVC0004DIsCur(Map<String, Object> params) {
    LOGGER.debug("== updateSVC0004DIsCur - START");
    LOGGER.debug("== PARAMS {} ", params);

    int a = ASManagementListMapper.updateSVC0004DIsCur(params);

    LOGGER.debug("== updateSVC0004DIsCur - END");

    return a;
  }

  /**
   * SVC0004D insert
   *
   * @param params
   * @return
   */
  public int insertInHouseSVC0004D(Map<String, Object> params) {
    LOGGER.debug("                          ===> insertInHouseSVC0004D  in");
    // SVC0004D insert 상태 업데이트
    LOGGER.debug("                  insertInHouseSVC0004D {} ", params);

    int a = ASManagementListMapper.insertSVC0004D(params);

    // in house 구분 물류 처리 한다.
    if (a > 0) {

      if (params.get("AS_RESULT_STUS_ID").equals("4")) {

        // AS_SLUTN_RESN_ID
        if (params.get("AS_SLUTN_RESN_ID").equals("454")) {

          // 차감 요청
          if (params.get("IN_HUSE_REPAIR_SERIAL_NO").toString().trim().length() > 0) {
            //
            // //이관 요청
            // //물류 호출 add by hgham
            // Map<String, Object> logPram = null ;
            // /////////////////////////물류 호출//////////////////////
            // logPram =new HashMap<String, Object>();
            // logPram.put("ORD_ID", params.get("AS_NO") );
            // logPram.put("RETYPE", "");
            // logPram.put("P_TYPE", "");
            // logPram.put("P_PRGNM", "INHOUS_1");
            // logPram.put("USERID", String.valueOf(params.get("updator")));
            //
            //
            // Map SRMap=new HashMap();
            // LOGGER.debug("ASManagementListServiceImpl.insertInHouseSVC0004D
            // INHOUS 물류 호출 PRAM ===>"+ logPram.toString());
            // servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
            // LOGGER.debug("ASManagementListServiceImpl.insertInHouseSVC0004D
            // INHOUS 물류 호출 결과 ===>" +logPram.toString());
            // logPram.put("P_RESULT_TYPE", "AS");
            // logPram.put("P_RESULT_MSG", logPram.get("p1"));
            //
            // /////////////////////////물류 호출 END //////////////////////

          } else {

            // //이관 요청
            // //물류 호출 add by hgham
            // Map<String, Object> logPram = null ;
            // /////////////////////////물류 호출//////////////////////
            // logPram =new HashMap<String, Object>();
            // logPram.put("ORD_ID", params.get("AS_NO") );
            // logPram.put("RETYPE", "");
            // logPram.put("P_TYPE", "");
            // logPram.put("P_PRGNM", "INHOUS_2");
            // logPram.put("USERID", String.valueOf(params.get("updator")));
            //
            //
            // Map SRMap=new HashMap();
            // LOGGER.debug("ASManagementListServiceImpl.insertInHouseSVC0004D
            // INHOUS 물류 호출 PRAM ===>"+ logPram.toString());
            // servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
            // LOGGER.debug("ASManagementListServiceImpl.insertInHouseSVC0004D
            // INHOUS 물류 호출 결과 ===>" +logPram.toString());
            // logPram.put("P_RESULT_TYPE", "AS");
            // logPram.put("P_RESULT_MSG", logPram.get("p1"));
            //
            // /////////////////////////물류 호출 END //////////////////////

          }
        }
      }
    }

    LOGGER.debug(" insertInHouseSVC0004D  결과 {}", a);
    LOGGER.debug("          ===> insertInHouseSVC0004D  out ");

    return a;
  }

  /**
   * SVC0005D insert
   *
   * @param params
   * @return
   */
  public int insertSVC0005D(List<EgovMap> addItemList, String AS_RESULT_ID, String UPDATOR) {
    LOGGER.debug("== INSERT FILTER CHANGE - START");
    int rtnValue = -1;
    if (addItemList.size() > 0) {
      for (int i = 0; i < addItemList.size(); i++) {

        Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
        Map<String, Object> iMap = new HashMap();

        if (!"".equals(updateMap.get("filterDesc"))) {

          String temp = (String) updateMap.get("filterDesc");

          if (!temp.equals("API")) {
            String[] animals = temp.split("-");

            if (animals.length > 0) {
              iMap.put("ASR_ITM_PART_DESC", animals[1]);
            } else {
              iMap.put("ASR_ITM_PART_DESC", "");
            }
          }

        }

        String strFilterID = String.valueOf(updateMap.get("filterId")) != "null"
            ? String.valueOf(updateMap.get("filterId")) : String.valueOf(updateMap.get("filterID"));

        iMap.put("AS_RESULT_ID", AS_RESULT_ID);
        iMap.put("ASR_ITM_PART_ID", strFilterID.trim());
        iMap.put("ASR_ITM_PART_QTY", updateMap.get("filterQty"));
        iMap.put("ASR_ITM_PART_PRC", updateMap.get("filterPrice"));
        iMap.put("ASR_ITM_CHRG_AMT", updateMap.get("filterTotal"));
        iMap.put("ASR_ITM_REM", updateMap.get("filterRemark"));
        iMap.put("ASR_ITM_CRT_USER_ID", UPDATOR);

        if (updateMap.get("filterType").equals("FOC")) {
          iMap.put("ASR_ITM_CHRG_FOC", "1");
        } else {
          iMap.put("ASR_ITM_CHRG_FOC", "0");
        }

        // iMap.put("ASR_ITM_EXCHG_ID", updateMap.get("filterExCode") != "-" ?
        // updateMap.get("filterExCode") : "0"); //cyc
        iMap.put("ASR_ITM_EXCHG_ID", updateMap.get("filterExCode"));// cyc
        iMap.put("ASR_ITM_CLM", "0");
        iMap.put("ASR_ITM_TAX_CODE_ID", "0");
        iMap.put("ASR_ITM_TXS_AMT", "0");

        iMap.put("SERIAL_NO", updateMap.get("srvFilterLastSerial"));
        iMap.put("FILTER_BARCD_SERIAL_NO", updateMap.get("srvFilterLastSerial"));
        iMap.put("EXCHG_ID", updateMap.get("filterExCode"));

        // KR-JIN
        if (StringUtils.isNotBlank((String) updateMap.get("retSmoSerialNo"))) {
          iMap.put("RET_SMO_SERIAL_NO", updateMap.get("retSmoSerialNo"));
        } else {
          iMap.put("RET_SMO_SERIAL_NO", null);
        }

        if (StringUtils.isNotBlank((String) updateMap.get("isSmo"))) {
          iMap.put("IS_SMO", updateMap.get("isSmo"));
        } else {
          iMap.put("IS_SMO", "N");
        }

        if (StringUtils.isNotBlank((String) updateMap.get("isSerialReplace"))) {
          iMap.put("IS_SERIAL_REPLACE", updateMap.get("isSerialReplace"));
        } else {
          iMap.put("IS_SERIAL_REPLACE", "N");
        }

        LOGGER.debug("== INSERT SVC0005D PARAMS {}", iMap);
        rtnValue = ASManagementListMapper.insertSVC0005D(iMap);
      }
    }
    LOGGER.debug("== INSERT FILTER CHANGE - END");
    return rtnValue;
  }

  /**
   * LOG0103M INSERT - AS'S USED FILTER
   *
   * @param string
   *
   * @param params
   * @return
   */
  public int insertLOG0103M(List<EgovMap> addItemList, String AS_NO, Map obj, String UPDATOR) {
    LOGGER.debug("== INSERT USED FILTER - START");
    int rtnValue = -1;
    if (addItemList.size() > 0) {
      for (int i = 0; i < addItemList.size(); i++) {

        Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
        Map<String, Object> iMap = new HashMap();

        String strFilterID = String.valueOf(updateMap.get("filterId")) != "null"
            ? String.valueOf(updateMap.get("filterId")) : String.valueOf(updateMap.get("filterID"));

        iMap.put("AS_NO", AS_NO);
        iMap.put("AS_PART_ID", strFilterID.trim());
        iMap.put("AS_PART_QTY", updateMap.get("filterQty"));
        iMap.put("AS_UPD_UST", UPDATOR);
        iMap.put("ASR_NO", obj.get("AS_RESULT_ID"));
        iMap.put("ASR_CT", obj.get("AS_CT_ID"));
        iMap.put("ASR_SETL_DT", obj.get("AS_SETL_DT"));
        // iMap.put("SERIAL_NO", updateMap.get("srvFilterLastSerial"));
        // iMap.put("FILTER_BARCD_SERIAL_NO", updateMap.get("srvFilterLastSerial"));

        LOGGER.debug("== INSERT LOG0103M PARAMS {}", iMap);
        rtnValue = ASManagementListMapper.insertLOG0103M(iMap);
      }
    }
    LOGGER.debug("== INSERT USED FILTER - END");
    return rtnValue;
  }

  /**
   * insert_stkCardLOG0014D insert
   *
   * @param params
   * @return
   */
  // public int insert_stkCardLOG0014D(List <EgovMap> addItemList , String
  // AS_RESULT_ID , String UPDATOR ,LinkedHashMap svc0004dmap ){
  public int insert_stkCardLOG0014D(List<EgovMap> addItemList, String AS_RESULT_ID, String UPDATOR, Map svc0004dmap) {// hash

    LOGGER.debug("                          ===> insert_stkCardLOG0014D  in ");
    int rtnValue = -1;
    if (addItemList.size() > 0) {
      for (int i = 0; i < addItemList.size(); i++) {

        Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
        Map<String, Object> map = new HashMap();

        map.put("locId", "0");
        map.put("stockId", updateMap.get("filterID"));
        map.put("entryDt", new Date());
        map.put("typeId", "461");
        map.put("refNo", svc0004dmap.get("AS_NO"));
        map.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
        map.put("itmNo", (i + 1));
        map.put("srcId", "477");
        map.put("prjctId", "0");
        map.put("batchNo", "0");
        map.put("qty", (-1 * Integer.parseInt(String.valueOf((updateMap.get("filterQty"))))));
        map.put("currId", "479");
        map.put("currRate", "1");
        map.put("cost", "0");
        map.put("prc", "0");
        map.put("rem", "");
        map.put("serialNo", "");
        map.put("installNo", svc0004dmap.get("AS_RESULT_NO"));
        map.put("costDt", "01/01/1900");
        map.put("appTypeId", "0");
        map.put("stkGrad", "A");
        map.put("installFail", "0");
        map.put("isSynch", "0");
        map.put("entryMthId", "764");
        map.put("orgn", "");
        map.put("transType", "");
        map.put("docLneNo", "0");
        map.put("poNo", "");
        map.put("insertDt", new Date());
        map.put("isGr", "0");
        map.put("poStus", "");
        LOGGER.debug("                  insertSVC0005D {} ", map);

        Map<String, Object> map87mp = new HashMap();
        map87mp.put("SRV_FILTER_PRV_CHG_DT", svc0004dmap.get("AS_SETL_DT"));
        map87mp.put("SRV_FILTER_STK_ID", updateMap.get("filterID"));
        map87mp.put("SRV_FILTER_LAST_SERIAL", updateMap.get("srvFilterLastSerial"));
        map87mp.put("SRV_SO_ID", svc0004dmap.get("AS_SO_ID"));
        map87mp.put("updator", svc0004dmap.get("updator"));

        int update_SAL0087D_cnt = ASManagementListMapper.update_SAL0087D(map87mp);
        /*
         * rtnValue = ASManagementListMapper.insert_stkCardLOG0014D(map) ; xml에 없어서 임시주석
         */

      }
    }

    LOGGER.debug(" insert_stkCardLOG0014D  결과 {}", rtnValue);
    LOGGER.debug("                          ===> insert_stkCardLOG0014D  out ");
    return rtnValue;
  }

  // invoice
  public int setPay31dData(ArrayList<AsResultChargesViewVO> vewList, Map<String, Object> params) {

    LOGGER.debug("                                  ===> setPay31dData   in");
    LOGGER.debug("params : {}", params);
    Map<String, Object> pay31dMap = new HashMap();

    double totalCharges = 0;
    double totalTaxes = 0;
    double totalAmountDue = 0;

    if (vewList.size() > 0) {
      for (AsResultChargesViewVO vo : vewList) {

        totalCharges += Double.parseDouble(vo.getSpareCharges());
        totalTaxes += Double.parseDouble(vo.getSpareTaxes());
        totalAmountDue += Double.parseDouble(vo.getSpareAmountDue());
      }
    }

    // tax invoice ,
    EgovMap taxPersonInfo = ASManagementListMapper.selectTaxInvoice(params);

    pay31dMap.put("taxInvcId", params.get("taxInvcId"));
    pay31dMap.put("taxInvcRefNo", params.get("taxInvcRefNo"));
    pay31dMap.put("taxInvcRefDt", "");
    pay31dMap.put("taxInvcSvcNo", params.get("AS_RESULT_NO"));
    pay31dMap.put("taxInvcType", "118");

    try {
      pay31dMap.put("taxInvcCustName", taxPersonInfo.get("taxInvoiceCustName"));
      pay31dMap.put("taxInvcCntcPerson", taxPersonInfo.get("taxInvoiceContPers"));
    } catch (Exception e) {

      pay31dMap.put("taxInvcCustName", "");
      pay31dMap.put("taxInvcCntcPerson", "");

    }

    pay31dMap.put("taxInvcAddr1", "");
    pay31dMap.put("taxInvcAddr2", "");
    pay31dMap.put("taxInvcAddr3", "");
    pay31dMap.put("taxInvcAddr4", "");
    pay31dMap.put("taxInvcPostCode", "");
    pay31dMap.put("taxInvcStateName", "");
    pay31dMap.put("taxInvcCnty", "");
    pay31dMap.put("taxInvcTaskId", "");
    pay31dMap.put("taxInvcRem", "");
    pay31dMap.put("taxInvcChrg", Double.toString(totalCharges));
    pay31dMap.put("taxInvcTxs", Double.toString(totalTaxes));
    pay31dMap.put("taxInvcAmtDue", Double.toString(totalAmountDue));
    pay31dMap.put("taxInvcCrtDt", new Date());
    pay31dMap.put("taxInvcCrtUserId", params.get("updator"));

    pay31dMap.put("AS_SO_ID", params.get("AS_SO_ID"));

    int a = ASManagementListMapper.insert_Pay0031d(pay31dMap);

    LOGGER.debug(" pay31dMap {}", pay31dMap.toString());
    LOGGER.debug(" pay31dMap  결과 {}", a);
    LOGGER.debug("                                  ===> setPay31dData   out");
    return a;

  }

  public int setPay32dData(ArrayList<AsResultChargesViewVO> vewList, Map<String, Object> params) {
    LOGGER.debug("========================setPay32dData - START ===========================");
    Map<String, Object> pay32dMap = new HashMap();

    int a = -1;
    if (vewList.size() > 0) {
      for (AsResultChargesViewVO vo : vewList) {
        pay32dMap.put("taxInvcId", params.get("taxInvcId"));
        pay32dMap.put("invcItmType", vo.getAsChargesTypeId());
        pay32dMap.put("invcItmOrdNo", params.get("AS_SO_ID"));
        pay32dMap.put("invcItmPoNo", "");
        pay32dMap.put("invcItmCode", vo.getSparePartCode());
        pay32dMap.put("invcItmDesc1", vo.getSparePartName());
        pay32dMap.put("invcItmDesc2", "");
        pay32dMap.put("invcItmSerialNo", "");
        pay32dMap.put("invcItmQty", vo.getAsChargeQty());
        pay32dMap.put("invcItmUnitPrc", "");
        pay32dMap.put("invcItmTaxCodeId", vo.getGstCode());
        pay32dMap.put("invcItmGstRate", vo.getGstRate());
        pay32dMap.put("invcItmGstTxs", vo.getSpareTaxes());
        pay32dMap.put("invcItmChrg", vo.getSpareCharges());
        pay32dMap.put("invcItmAmtDue", vo.getSpareAmountDue());
        pay32dMap.put("invcItmAdd1", "");
        pay32dMap.put("invcItmAdd2", "");
        pay32dMap.put("invcItmAdd3", "");
        pay32dMap.put("invcItmAdd4", "");
        pay32dMap.put("invcItmPostCode", "");
        pay32dMap.put("invcItmAreaName", "");
        pay32dMap.put("invcItmStateName", "");
        pay32dMap.put("invcItmCnty", "");
        pay32dMap.put("invcItmInstallDt", "");
        pay32dMap.put("invcItmRetnDt", "");
        pay32dMap.put("invcItmBillRefNo", "");

        LOGGER.debug("== PAY0032D {}", pay32dMap.toString());

        a = ASManagementListMapper.insert_Pay0032d(pay32dMap);

        LOGGER.debug("= NUMBER OF ROW AFFECTED :: " + a);
        LOGGER.debug("========================setPay32dData - END ===========================");
      }
    }
    return a;
  }

  public int setPay16dPartData(ArrayList<AsResultChargesViewVO> vewList, Map<String, Object> params) {
    LOGGER.debug("                                  ===> setPay16dPartData   in");

    Map<String, Object> pay0016dMap = new HashMap();

    double partCharges = 0;
    double partTaxes = 0;
    double partAmountDue = 0;

    int a = -1;

    if (vewList.size() > 0) {
      for (AsResultChargesViewVO vo : vewList) {
        if (vo.getAsChargesTypeId().equals("1262")) {
          partCharges += Double.parseDouble((vo.getSpareCharges()));
          partTaxes += Double.parseDouble((vo.getSpareTaxes()));
          partAmountDue += Double.parseDouble((vo.getSpareAmountDue()));
        }
      }
    }

    pay0016dMap.put("accBillTaskId", "0");
    pay0016dMap.put("accBillRefDt", new Date());
    pay0016dMap.put("accBillRefNo", "1000");
    pay0016dMap.put("accBillOrdId", params.get("AS_SO_ID"));
    pay0016dMap.put("accBillTypeId", "1159");
    pay0016dMap.put("accBillModeId", "1263");
    pay0016dMap.put("accBillSchdulId", "0");
    pay0016dMap.put("accBillSchdulPriod", "0");
    pay0016dMap.put("accBillAdjId", "0");
    pay0016dMap.put("accBillSchdulAmt", Double.toString(partAmountDue));
    pay0016dMap.put("accBillAdjAmt", "0");
    pay0016dMap.put("accBillTxsAmt", Double.toString(partTaxes));
    pay0016dMap.put("accBillNetAmt", Double.toString(partAmountDue));
    pay0016dMap.put("accBillStus", "1");
    pay0016dMap.put("accBillRem", params.get("taxInvcRefNo"));
    pay0016dMap.put("accBillCrtDt", new Date());
    pay0016dMap.put("accBillCrtUserId", params.get("updator"));
    pay0016dMap.put("accBillGrpId", "0");
    pay0016dMap.put("accBillTaxCodeId", params.get("TaxCode"));
    pay0016dMap.put("accBillTaxRate", params.get("TaxRate"));
    pay0016dMap.put("accBillAcctCnvr", "0");
    pay0016dMap.put("accBillCntrctId", "0");

    a = ASManagementListMapper.insert_Pay0016d(pay0016dMap);

    LOGGER.debug(" setPay16dPartData {}", pay0016dMap.toString());
    LOGGER.debug(" setPay16dPartData  결과 {}", a);
    LOGGER.debug("                                  ===> setPay16dPartData   out");

    return a;
  }

  public int setPay16dLabourData(ArrayList<AsResultChargesViewVO> vewList, Map<String, Object> params) {
    LOGGER.debug("                                  ===> setPay16dLabourData   in");
    Map<String, Object> pay0016dMap = new HashMap();

    double labourCharges = 0;
    double labourTaxes = 0;
    double labourAmountDue = 0;

    if (vewList.size() > 0) {
      for (AsResultChargesViewVO vo : vewList) {
        if (vo.getAsChargesTypeId().equals("1261")) {
          labourCharges += Double.parseDouble((vo.getSpareCharges()));
          labourTaxes += Double.parseDouble((vo.getSpareTaxes()));
          labourAmountDue += Double.parseDouble((vo.getSpareAmountDue()));
        }
      }
    }

    int a = -1;

    pay0016dMap.put("accBillTaskId", "0");
    pay0016dMap.put("accBillRefDt", new Date());
    pay0016dMap.put("accBillRefNo", "1000");
    pay0016dMap.put("accBillOrdId", params.get("AS_SO_ID"));
    pay0016dMap.put("accBillTypeId", "1159");
    pay0016dMap.put("accBillModeId", "1264");
    pay0016dMap.put("accBillSchdulId", "0");
    pay0016dMap.put("accBillSchdulPriod", "0");
    pay0016dMap.put("accBillAdjId", "0");
    pay0016dMap.put("accBillSchdulAmt", Double.toString(labourAmountDue));
    pay0016dMap.put("accBillAdjAmt", "0");
    pay0016dMap.put("accBillTxsAmt", Double.toString(labourTaxes));
    pay0016dMap.put("accBillNetAmt", Double.toString(labourAmountDue));
    pay0016dMap.put("accBillStus", "1");
    pay0016dMap.put("accBillRem", params.get("taxInvcRefNo"));
    pay0016dMap.put("accBillCrtDt", new Date());
    pay0016dMap.put("accBillCrtUserId", params.get("updator"));
    pay0016dMap.put("accBillGrpId", "0");
    pay0016dMap.put("accBillTaxCodeId", params.get("package_TAXCODE"));
    pay0016dMap.put("accBillTaxRate", params.get("package_TAXRATE"));
    pay0016dMap.put("accBillAcctCnvr", "0");
    pay0016dMap.put("accBillCntrctId", "0");

    a = ASManagementListMapper.insert_Pay0016d(pay0016dMap);

    LOGGER.debug(" setPay16dLabourData {}", pay0016dMap.toString());
    LOGGER.debug(" setPay16dLabourData  결과 {}", a);
    LOGGER.debug("                                  ===> setPay16dLabourData   out");
    return a;
  }

  // AccBilling
  public int setPay0007dData(ArrayList<AsResultChargesViewVO> vewList, Map<String, Object> params, String billIsPaid) {

    LOGGER.debug("                                  ===> setPay0007dData   in");

    Map<String, Object> pay0007dMap = new HashMap();

    // 채번
    // int billId = posMapper.getSeqPay0007D();

    // pay0007dMap.put("billId",Integer.toString(billId));
    pay0007dMap.put("billTypeId", "238");
    pay0007dMap.put("billSoId", params.get("AS_SO_ID"));
    pay0007dMap.put("billMemId", "0");
    pay0007dMap.put("billAsId", params.get("AS_ENTRY_ID"));
    pay0007dMap.put("billPayTypeId", "");
    pay0007dMap.put("billNo", params.get("AS_RESULT_NO"));
    pay0007dMap.put("billMemShipNo", params.get("asBillNo"));
    pay0007dMap.put("billDt", new Date());
    pay0007dMap.put("billAmt", params.get("AS_TOT_AMT"));
    pay0007dMap.put("billRem", "");
    pay0007dMap.put("billIsPaid", billIsPaid);
    pay0007dMap.put("billIsComm", params.get("AS_CMMS"));
    pay0007dMap.put("updUserId", params.get("updator"));
    pay0007dMap.put("updDt", new Date());
    pay0007dMap.put("syncChk", "0");
    pay0007dMap.put("coursId", "0");
    pay0007dMap.put("stusId", "1");

    int a = ASManagementListMapper.insert_Pay0007d(pay0007dMap);

    LOGGER.debug(" pay0007dMap {}", pay0007dMap.toString());
    LOGGER.debug(" pay0007dMap  결과 {}", a);
    LOGGER.debug("                                  ===> pay0007dMap   out");

    return a;
  }

  // AccASLedger
  public int setPay0006dData(ArrayList<AsResultChargesViewVO> vewList, Map<String, Object> params, String type,
      double totalASAmount) {
    LOGGER.debug("                                  ===> setPay0006dData   in");
    Map<String, Object> pay0006dMap = new HashMap();

    pay0006dMap.put("asId", params.get("AS_ENTRY_ID"));
    pay0006dMap.put("asDocNo", params.get("AS_RESULT_NO"));
    pay0006dMap.put("asLgDocTypeId", "163");
    pay0006dMap.put("asLgDt", new Date());

    if ("A".equals(type)) {
      pay0006dMap.put("asLgAmt", totalASAmount);
      // pay0006dMap.put("asLgAmt",params.get("AS_TOT_AMT"));

    } else if ("B".equals(type)) {
      pay0006dMap.put("asLgAmt", totalASAmount * -1);
      // pay0006dMap.put("asLgAmt" ,
      // Double.parseDouble((String)params.get("AS_TOT_AMT")) * -1 );

    } else if ("C".equals(type)) {
      pay0006dMap.put("asLgAmt", Double.parseDouble((String) params.get("totalAASLeft")) * -1);
    }

    pay0006dMap.put("asLgUpdUserId", params.get("updator"));
    pay0006dMap.put("asLgUpdDt", new Date());
    // pay0006dMap.put("asSoNo",""); //AS_SO_ID select
    pay0006dMap.put("asResultNo", params.get("AS_RESULT_NO"));
    pay0006dMap.put("asSoId", params.get("AS_SO_ID"));
    pay0006dMap.put("asAdvPay", "0");
    pay0006dMap.put("r01", "0");

    int a = ASManagementListMapper.insert_Pay0006d(pay0006dMap);

    LOGGER.debug(" pay0006dMap {}", pay0006dMap.toString());
    LOGGER.debug(" pay0006dMap  결과 {}", a);
    LOGGER.debug("                                  ===> pay0006dMap   out");

    return a;
  }

  public int updateSTATE_CCR0006D(Map<String, Object> params) {
    LOGGER.debug("== UPDATE CCR0006D - START");
    int a = ASManagementListMapper.updateSTATE_CCR0006D(params);
    LOGGER.debug("== UPDATE CCR0006D - END");
    return a;
  }

  public int setCCR0001DData(Map<String, Object> params) {
    LOGGER.debug("== setCCR0001DData = INSERT HAPPY CALL - START");

    Map<String, Object> ccr01dMap = new HashMap();

    ccr01dMap.put("hcsoid", params.get("AS_SO_ID"));
    ccr01dMap.put("hcTypeNo", params.get("AS_NO"));
    ccr01dMap.put("hcCallEntryId", "0");
    ccr01dMap.put("hcTypeId", "510");
    ccr01dMap.put("hcStusId", "33");
    ccr01dMap.put("hcRem", "");
    ccr01dMap.put("hcCommentTypeId", "0");
    ccr01dMap.put("hcCommentGid", "0");
    ccr01dMap.put("hcCommentSid", "0");
    ccr01dMap.put("hcCommentDid", "0");
    ccr01dMap.put("crtUserId", params.get("updator"));
    ccr01dMap.put("crtDt", new Date());
    ccr01dMap.put("updUserId", params.get("updator"));
    ccr01dMap.put("updDt", new Date());
    ccr01dMap.put("hcNoSvc", "0");
    ccr01dMap.put("hcLok", "0");
    ccr01dMap.put("hcClosId", "0");

    int a = ASManagementListMapper.insert_Ccr0001d(ccr01dMap);

    LOGGER.debug("== TOTAL NO. INSERT - ", a);
    LOGGER.debug("== setCCR0001DData = INSERT HAPPY CALL - END");

    return a;
  }

  public boolean geGST_CHK(Map<String, Object> params) {
    boolean isgST = false;
    EgovMap gstChk = ASManagementListMapper.geGST_CHK(params);
    String gst = "1";

    if (null != gstChk) {
      gst = (String) gstChk.get("GST_CHK");
    }

    if ("1".equals(gst)) {
      isgST = false;
    } else {
      isgST = true;
    }

    return isgST;
  }

  /**
   * 1.In-house phase 3 AUTOINSERT false 2.In-house Phase 1 B8 Request if FALSE B8 Inventory after request TRUE if request 3.
   *
   * @param svc0004dmap
   * @return
   */
  public boolean chkInHouseOpenComp(Map<String, Object> svc0004dmap) {
    LOGGER.debug("================chkInHouseOpenComp - START ================");
    LOGGER.debug("== SVC0004D MAP : " + svc0004dmap.toString());
    LOGGER.debug("================chkInHouseOpenComp - END ================");

    boolean chkInHouseOpenComp = false;

    if (CommonUtils.nvl(svc0004dmap.get("AUTOINSERT")).toString().equals("TRUE")) {
      return chkInHouseOpenComp;
    }

    // SERIAL NUMBER UPDATE ON RESULT FROM MOBILE
    /*
     * SOLUTION CODE DESCRIPTIION ===================================== 454 REPAIR 452 REPAIR OUT =====================================
     */

    if (CommonUtils.nvl(svc0004dmap.get("AS_SLUTN_RESN_ID")).toString().equals("454")
        && !"WEB".equals(CommonUtils.nvl(svc0004dmap.get("CHANGBN")).toString())) {
      /*
       * if (CommonUtils.nvl(svc0004dmap.get("IN_HUSE_REPAIR_SERIAL_NO")).toString( ).trim().length() != 0) { svc0004dmap.put("AS_RESULT_STUS_ID", "4"); // COMPLETE this.updateStateSVC0001D(svc0004dmap); this.updateState_SERIAL_NO_SVC0004D(svc0004dmap); chkInHouseOpenComp = true; }
       */

      /*
       * if(svc0004dmap.get("IN_HUSE_REPAIR_REPLACE_YN") != null) { if (svc0004dmap.get("IN_HUSE_REPAIR_REPLACE_YN").equals("0")) { svc0004dmap.put("AS_RESULT_STUS_ID", "4"); this.updateStateSVC0001D(svc0004dmap); } }
       */

      // REPLACEMENT
      /*
       * 0 - NO 1 - YES
       */
      LOGGER.debug("================chkInHouseOpenComp - 1 ================");
      if (svc0004dmap.get("IN_HUSE_REPAIR_REPLACE_YN") != null) {
        LOGGER.debug("================chkInHouseOpenComp - 2 ================");
        if ((svc0004dmap.get("IN_HUSE_REPAIR_REPLACE_YN").toString().trim()).equals("0")) {
          LOGGER.debug("================chkInHouseOpenComp - 3 ================");
          svc0004dmap.put("AS_RESULT_STUS_ID", "4");
          this.updateStateSVC0001D(svc0004dmap);
          chkInHouseOpenComp = false;
          LOGGER.debug("================chkInHouseOpenComp - 4 ================");
        } else {
          if (CommonUtils.nvl(svc0004dmap.get("IN_HUSE_REPAIR_SERIAL_NO")).toString().trim().length() != 0) {
            svc0004dmap.put("AS_RESULT_STUS_ID", "4"); // COMPLETE
            this.updateStateSVC0001D(svc0004dmap);
            this.updateState_SERIAL_NO_SVC0004D(svc0004dmap);
            chkInHouseOpenComp = true;
          }
        }
      }
    }

    if (CommonUtils.nvl(svc0004dmap.get("AS_SLUTN_RESN_ID")).toString().equals("452")
        && !"WEB".equals(CommonUtils.nvl(svc0004dmap.get("CHANGBN")).toString())) {
      if (svc0004dmap.get("IN_HUSE_REPAIR_SERIAL_NO").toString().trim().length() != 0) {
        svc0004dmap.put("AS_RESULT_STUS_ID", "4");
        this.updateStateSVC0001D(svc0004dmap);
        // this.updateState_SERIAL_NO_SVC0004D(svc0004dmap);
        chkInHouseOpenComp = true;
      }

      if (svc0004dmap.get("IN_HUSE_REPAIR_REPLACE_YN") != null) {
        if ((svc0004dmap.get("IN_HUSE_REPAIR_REPLACE_YN").toString().trim()).equals("0")) {
          chkInHouseOpenComp = false;
        } else {
          svc0004dmap.put("AS_RESULT_STUS_ID", "4");
          this.updateStateSVC0001D(svc0004dmap);
          chkInHouseOpenComp = true;
        }
      }
    }

    return chkInHouseOpenComp;
  }

  @Override
  public EgovMap asResult_insert(Map<String, Object> params) {
    LOGGER.debug("================asResult_insert - START ================");
    LOGGER.debug("asResult_insert11111 :" + params.toString());

    String m = "";
    Map svc0004dmap = (Map) params.get("asResultM");
    svc0004dmap.put("updator", params.get("updator"));

    String zeroRatYn = "Y";
    String eurCertYn = "Y";

    Map tm = new HashMap();
    tm.put("srvSalesOrderId", svc0004dmap.get("AS_SO_ID"));

    int zeroRat = membershipRentalQuotationMapper.selectGSTZeroRateLocation(tm);
    int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(tm);

    // 2018-05-24 - Kit Wai - Update GST to 0%
    // int package_TAXRATE =6;
    int package_TAXRATE = 0;
    int package_TAXCODE = 32;

    // 2018-05-24 - Kit Wai - Update GST to 0%
    // int filter_TAXRATE =6;
    int filter_TAXRATE = 0;
    int filter_TAXCODE = 32;

    // PACKAGE
    if (EURCert > 0) {
      package_TAXRATE = 0;
      package_TAXCODE = 28;

    }
    // FILTER
    if (zeroRat > 0) {
      filter_TAXRATE = 0;
      filter_TAXCODE = 39;
    }

    if (EURCert > 0) {
      filter_TAXRATE = 0;
      filter_TAXCODE = 28;
    }

    params.put("DOCNO", "21");
    EgovMap eMap = ASManagementListMapper.getASEntryDocNo(params);
    EgovMap seqMap = ASManagementListMapper.getResultASEntryId(params); // GET NEXT SEQ FOR SVC0004D RESULT ID

    String AS_RESULT_ID = String.valueOf(seqMap.get("seq"));

    LOGGER.debug("== NEW AS RESULT ID = " + AS_RESULT_ID);
    LOGGER.debug("== NEW ASR RESULT NO = " + eMap.get("asno"));

    ArrayList<AsResultChargesViewVO> vewList = new ArrayList<AsResultChargesViewVO>();
    List<EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);

    svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
    svc0004dmap.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));

    LOGGER.debug("================asResult_insert - HAPPY CALL - START ================");
    this.setCCR0001DData(svc0004dmap);
    LOGGER.debug("================asResult_insert - HAPPY CALL - END ================");

    double AS_TOT_AMT = 0;
    AS_TOT_AMT = Double.parseDouble(String.valueOf(svc0004dmap.get("AS_TOT_AMT")));

    LOGGER.debug("== TOTAL AMOUNT " + AS_TOT_AMT);

    // INVOICE GENERATE START HERE ...

    if (AS_TOT_AMT > 0) { // TOTAL CHARGE AMOUNT MORE THAN 0
      // AS BILL NUMBER
      params.put("DOCNO", "22");
      EgovMap asBillDocNo = ASManagementListMapper.getASEntryDocNo(params);
      svc0004dmap.put("asBillNo", String.valueOf(asBillDocNo.get("asno")));

      LOGGER.debug("== AS BILL NUMBER " + asBillDocNo);

      // AS INVOICE NUMBER
      params.put("DOCNO", "128");
      EgovMap invoiceDocNo = ASManagementListMapper.getASEntryDocNo(params);
      svc0004dmap.put("taxInvcRefNo", String.valueOf(invoiceDocNo.get("asno")));

      LOGGER.debug("== AS INVOICE NUMBER " + invoiceDocNo);

      int taxInvcId = posMapper.getSeqPay0031D();
      // int invcItmId = posMapper.getSeqPay0032D();
      svc0004dmap.put("taxInvcId", String.valueOf(taxInvcId));
      // svc0004dmap.put("invcItmId", String.valueOf(invcItmId)) ;

      LOGGER.debug("== AS INVOICE PAY0031D NUMBER " + taxInvcId);

      EgovMap sumLeftMap = ASManagementListMapper.geTtotalAASLeft(svc0004dmap);

      LOGGER.debug("== AS SUM LEFT MAP " + sumLeftMap);

      // LABOUR CHARGE
      if (Double.parseDouble((String) svc0004dmap.get("AS_WORKMNSH")) > 0) {
        double txtLabourCharge = Double.parseDouble((String) svc0004dmap.get("AS_WORKMNSH"));
        double t_SpareCharges = 0.00;

        EgovMap sstInfo = commonService.getSstRelatedInfo();

        if(sstInfo != null){
        	package_TAXRATE = Integer.parseInt(sstInfo.get("taxRate").toString()) ;
        }

        if (package_TAXRATE > 0) {
            package_TAXCODE = Integer.parseInt(sstInfo.get("codeId").toString()) ;
            DecimalFormat df = new DecimalFormat("#0.00");
            double roundedNumber = Double.parseDouble(df.format((txtLabourCharge / (100 + package_TAXRATE)  )*100));
            t_SpareCharges = roundedNumber;
        } else {
          t_SpareCharges = txtLabourCharge;//
        }

        double t_SpareTaxes = txtLabourCharge - t_SpareCharges;
        t_SpareTaxes = Math.round(t_SpareTaxes * 100.0) / 100.0;

        LOGGER.debug("== LABOUR CHARGE = " + txtLabourCharge);
        LOGGER.debug("== SPARE PART CHARGE = " + t_SpareCharges);
        LOGGER.debug("== SPARE PART TAX = " + t_SpareTaxes);

        // setAsChargesTypeId 1261
        AsResultChargesViewVO vo_1261 = null;
        vo_1261 = new AsResultChargesViewVO();
        vo_1261.setAsEntryId("");
        vo_1261.setAsChargesTypeId("1261");
        vo_1261.setAsChargeQty("1");
        vo_1261.setSparePartId("0");
        //rename for  part name
        vo_1261.setSparePartCode(CommonUtils.nvl(svc0004dmap.get("productCode")) == "" ? "LABOUR CHARGE" : CommonUtils.nvl(svc0004dmap.get("productCode")));
        vo_1261.setSparePartName(CommonUtils.nvl(svc0004dmap.get("productName")) == "" ? "LABOUR CHARGE" : CommonUtils.nvl(svc0004dmap.get("productName")));
        vo_1261.setSparePartSerial((String) svc0004dmap.get("serialNo"));
        vo_1261.setSpareCharges(Double.toString(t_SpareCharges)); //
        vo_1261.setSpareTaxes(Double.toString(t_SpareTaxes));
        vo_1261.setSpareAmountDue(Double.toString(txtLabourCharge));
        vo_1261.setGstRate(Integer.toString(package_TAXRATE));
        vo_1261.setGstCode(Integer.toString(package_TAXCODE));
        vewList.add(vo_1261);
      }

      // boolean isTaxCode_0 =this.geGST_CHK(svc0004dmap) ; //1 0 구분
      // isTaxCode_0 = false;

      boolean isTaxCode_0 = filter_TAXRATE == 0 ? true : false;

      // isTaxCode 0
      if (isTaxCode_0) {
        // SETTING THE VALUE AFTER THE CALL
        svc0004dmap.put("TaxCode", filter_TAXCODE);
        svc0004dmap.put("TaxRate", filter_TAXRATE);

        if (Double.parseDouble(String.valueOf(svc0004dmap.get("AS_FILTER_AMT"))) > 0) {
          if (addItemList.size() > 0) {
            LOGGER.debug("= START PREPARE DATE FOR FILTERS = NUMBER OF FILTER : " + addItemList.size());
            for (int i = 0; i < addItemList.size(); i++) {
              Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
              Map<String, Object> iMap = new HashMap();

              String tempFilterTotal = String.valueOf(updateMap.get("filterTotal"));

              if (tempFilterTotal.equals(null) || "null".equals(tempFilterTotal)) {
                tempFilterTotal = "0";
              }

              tempFilterTotal = tempFilterTotal.replaceAll("\\,", "");

              double ft = Double.parseDouble(CommonUtils.isEmpty(tempFilterTotal) == true ? "0" : tempFilterTotal);

              LOGGER.debug("= FILTER AMOUNT : " + tempFilterTotal);
              LOGGER.debug("= FILTER INFO : " + updateMap.toString());

              if (ft > 0) {
                String filterCode = "";
                String filterName = "";
                if (!"".equals(updateMap.get("filterDesc"))) {
                  String temp = (String) updateMap.get("filterDesc");
                  if (null != temp) {
                    if (!temp.equals("API")) {
                      String[] animals = temp.split("-");

                      if (animals.length > 0) {
                        filterCode = animals[0];
                        filterName = animals[1];
                      }
                    } else { // MOBILE APPS
                      String fltNm = ASManagementListMapper.getFltNm(CommonUtils.nvl(updateMap.get("filterId")) != ""
                          ? CommonUtils.nvl(updateMap.get("filterId")) : CommonUtils.nvl(updateMap.get("filterID")));

                      String[] animals = fltNm.split("[-]");

                      if (animals.length > 0) {
                        filterCode = animals[0];
                        filterName = animals[1];
                      }
                    }
                  }
                }

                String strFilterID1 = String.valueOf(updateMap.get("filterId"));
                String strFilterID2 = String.valueOf(updateMap.get("filterID"));

                // String strFilterID =
                // String.valueOf(updateMap.get("filterId")) != "null"
                // ? String.valueOf(updateMap.get("filterId")) :
                // String.valueOf(updateMap.get("filterID"));

                String strFilterID = CommonUtils.nvl(updateMap.get("filterId")) != ""
                    ? CommonUtils.nvl(updateMap.get("filterId")) : CommonUtils.nvl(updateMap.get("filterID"));

                // setAsChargesTypeId 1261
                AsResultChargesViewVO vo_filter = null;
                vo_filter = new AsResultChargesViewVO();
                vo_filter.setAsEntryId("");
                vo_filter.setAsChargesTypeId("1262");
                vo_filter.setAsChargeQty(String.valueOf(updateMap.get("filterQty")));
                vo_filter.setSparePartId(strFilterID);
                vo_filter.setSparePartCode(filterCode);
                vo_filter.setSparePartName(filterName);
                vo_filter.setSparePartSerial("");
                vo_filter.setSpareCharges(Double.toString(ft)); //
                vo_filter.setSpareTaxes("0");
                vo_filter.setSpareAmountDue(Double.toString(ft));
                vo_filter.setGstRate(Integer.toString(filter_TAXRATE));
                vo_filter.setGstCode(Integer.toString(filter_TAXCODE));

                vewList.add(vo_filter); // view.GSTCode =
                                        // ZRLocationID.ToString() == "0" ?
                                        // ZRLocationID.ToString() :
                                        // ZRLocationID.ToString();
              }
            }
          }
        }
      } else {
        svc0004dmap.put("TaxCode", filter_TAXCODE);
        svc0004dmap.put("TaxRate", filter_TAXRATE);

        // FILTER CHARGE
        if (Double.parseDouble(String.valueOf(svc0004dmap.get("AS_FILTER_AMT"))) > 0) {
          if (addItemList.size() > 0) {
            LOGGER.debug("= START PREPARE DATE FOR FILTERS = NUMBER OF FILTER : " + addItemList.size());
            for (int i = 0; i < addItemList.size(); i++) {
              Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
              Map<String, Object> iMap = new HashMap();

              String tempFilterTotal = String.valueOf(updateMap.get("filterTotal"));

              if (tempFilterTotal.equals(null) || "null".equals(tempFilterTotal)) {
                tempFilterTotal = "0";
              }

              double ft = Double.parseDouble(tempFilterTotal);
              LOGGER.debug("= FILTER AMOUNT : " + tempFilterTotal);
              LOGGER.debug("= FILTER INFO : " + updateMap.toString());

              if (ft > 0) {
                String filterCode = "";
                String filterName = "";
                if (!"".equals(updateMap.get("filterDesc"))) {
                  String temp = (String) updateMap.get("filterDesc");
                  if (null != temp) {
                    if (!temp.equals("API")) {
                      String[] animals = temp.split("-");
                      if (animals.length > 0) {
                        filterCode = animals[0];
                        filterName = animals[1];
                      }
                    } else { // MOBILE APPS
                      String fltNm = ASManagementListMapper.getFltNm(CommonUtils.nvl(updateMap.get("filterId")) != ""
                          ? CommonUtils.nvl(updateMap.get("filterId")) : CommonUtils.nvl(updateMap.get("filterID")));

                      String[] animals = fltNm.split("[-]");

                      if (animals.length > 0) {
                        filterCode = animals[0];
                        filterName = animals[1];
                      }
                    }
                  }
                }

                // double t_SpareCharges = (ft *100/106); / 2018-05-24 - Kit Wai
                // - 0% GST
                double t_SpareCharges = ft;
                double t_SpareTaxes = ft - t_SpareCharges;

                String strFilterID = CommonUtils.nvl(updateMap.get("filterId")) != ""
                    ? CommonUtils.nvl(updateMap.get("filterId")) : CommonUtils.nvl(updateMap.get("filterID"));

                // setAsChargesTypeId 1261
                AsResultChargesViewVO vo_filter32 = null;
                vo_filter32 = new AsResultChargesViewVO();
                vo_filter32.setAsEntryId("");
                vo_filter32.setAsChargesTypeId("1262");
                vo_filter32.setAsChargeQty(String.valueOf(updateMap.get("filterQty")));
                vo_filter32.setSparePartId(strFilterID);
                vo_filter32.setSparePartCode(filterCode);
                vo_filter32.setSparePartName(filterName);
                vo_filter32.setSparePartSerial("");
                vo_filter32.setSpareCharges(Double.toString(t_SpareCharges)); //
                vo_filter32.setSpareTaxes(Double.toString(t_SpareTaxes));
                vo_filter32.setSpareAmountDue(Double.toString(ft));
                vo_filter32.setGstRate(Integer.toString(filter_TAXRATE));
                vo_filter32.setGstCode(Integer.toString(filter_TAXCODE));

                vewList.add(vo_filter32); // view.GSTCode =
                                          // ZRLocationID.ToString() == "0" ?
                                          // ZRLocationID.ToString() :
                                          // ZRLocationID.ToString();
              }
            }
          }
        }
      } // isTaxCode_0 if eof

      this.setPay31dData(vewList, svc0004dmap);
      this.setPay32dData(vewList, svc0004dmap);

      double labourCharges = 0;
      double labourTaxes = 0;
      double labourAmountDue = 0;
      double partCharges = 0;
      double partTaxes = 0;
      double partAmountDue = 0;

      if (vewList.size() > 0) {
        for (AsResultChargesViewVO vo : vewList) {
          if (vo.getAsChargesTypeId().equals("1261")) {
            labourCharges += Double.parseDouble((vo.getSpareCharges()));
            labourTaxes += Double.parseDouble((vo.getSpareTaxes()));
            labourAmountDue += Double.parseDouble((vo.getSpareAmountDue()));
          } else if (vo.getAsChargesTypeId().equals("1262")) {
            partCharges += Double.parseDouble((vo.getSpareCharges()));
            partTaxes += Double.parseDouble((vo.getSpareTaxes()));
            partAmountDue += Double.parseDouble((vo.getSpareAmountDue()));
          }
        }
      }

      if (labourAmountDue > 0) {
        svc0004dmap.put("package_TAXRATE", package_TAXRATE);
        svc0004dmap.put("package_TAXCODE", package_TAXCODE);
        this.setPay16dLabourData(vewList, svc0004dmap);
      }

      if (partAmountDue > 0) {
        this.setPay16dPartData(vewList, svc0004dmap);
      }

      // GET TOTAL AS ITEM AMOUNT
      // double totalCharges =0;
      // double totalTaxes =0;
      double totalASAmount = 0;

      if (vewList.size() > 0) {
        for (AsResultChargesViewVO vo : vewList) {
          // totalCharges += Double.parseDouble(vo.getSpareCharges());
          // totalTaxes += Double.parseDouble(vo.getSpareTaxes());
          totalASAmount += Double.parseDouble(vo.getSpareAmountDue());
        }
      }

      svc0004dmap.put("AS_TOT_AMT", totalASAmount);

      boolean isBillIsPaid = false;

      this.setPay0006dData(vewList, svc0004dmap, "A", totalASAmount);

      double totalLgAmt = 0;
      double totalUsedLgAmt = 0;
      double totalAASLeft = 0;

      if (null != sumLeftMap) {
        totalLgAmt = Double.parseDouble(String.valueOf(sumLeftMap.get("totallgamt")));
        totalUsedLgAmt = Double.parseDouble(String.valueOf(sumLeftMap.get("totalusedlgamt")));
        totalAASLeft = Double.parseDouble(String.valueOf(sumLeftMap.get("totalaasleft")));
      }

      if (totalAASLeft > 0) {
        if (totalAASLeft >= AS_TOT_AMT) {
          isBillIsPaid = true;
          this.setPay0006dData(vewList, svc0004dmap, "B", totalASAmount);
        } else {
          svc0004dmap.put("totalAASLeft", String.valueOf(sumLeftMap.get("totalaasleft")));
          this.setPay0006dData(vewList, svc0004dmap, "C", totalASAmount);
        }
      }

      this.setPay0007dData(vewList, svc0004dmap, isBillIsPaid == true ? "1" : "0");

      if (labourTaxes > 0) {
        svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", package_TAXCODE);//sys0046d
      } else {
        svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", "0");
      }
      svc0004dmap.put("AS_WORKMNSH_TXS", Double.toString(labourTaxes));
    }
    // INVOICE GENERATE END HERE ...

    // CHECK ANY AS_RESULT_IS_CURR
    int z = this.updateSVC0004DIsCur(svc0004dmap);

    // INSERT SVC0004D RESULT
    int c = this.insertSVC0004D(svc0004dmap);
    // CALL ENTRY RESULT UPDATE
    int callint = updateSTATE_CCR0006D(svc0004dmap);
    // INSERT SVC0005D FILTER
    this.insertSVC0005D(addItemList, AS_RESULT_ID, String.valueOf(params.get("updator")));
    // INSERT USED FILTER
    this.insertLOG0103M(addItemList, svc0004dmap.get("AS_NO").toString(), svc0004dmap,
        String.valueOf(params.get("updator")));
    this.insert_stkCardLOG0014D(addItemList, AS_RESULT_ID, String.valueOf(params.get("updator")), svc0004dmap);

    svc0004dmap.put("AS_ID", svc0004dmap.get("AS_ENTRY_ID"));
    svc0004dmap.put("USER_ID", String.valueOf(svc0004dmap.get("updator")));

    // CHANGE IN AS_APP_TYPE IF IN_HOUSE_CLOSE IN-HOUSE ORDER IN MOBILE JOB LIST
    // HAS NOT BEEN LOWERED.
    if ("Y".equals((String) svc0004dmap.get("IN_HOUSE_CLOSE"))) {
      ASManagementListMapper.updateAS_TYPE_ID_SVC0001D(svc0004dmap);
    }

    // LOGISTIC REQUEST START HERE
    Map<String, Object> logPram = new HashMap<String, Object>();

    this.updateStateSVC0001D(svc0004dmap);

    if (String.valueOf(svc0004dmap.get("AS_RESULT_STUS_ID")).equals("4")) {
      ///////////////////////// LOGISTIC SP CALL //////////////////////
      logPram.put("ORD_ID", svc0004dmap.get("AS_NO"));
      logPram.put("RETYPE", "COMPLET");
      logPram.put("P_TYPE", "OD03");
      logPram.put("P_PRGNM", "ASCOM_3");
      logPram.put("USERID", String.valueOf(params.get("updator")));

      Map SRMap = new HashMap();
      LOGGER.debug("asResult_insert PARAM ===>" + logPram.toString());

      // KR-OHK Serial check add start
      if ("Y".equals(svc0004dmap.get("SERIAL_REQUIRE_CHK_YN"))) {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
      } else {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      }
      LOGGER.debug("asResult_insert PARAM ===>" + logPram.toString());

      if (!"000".equals(logPram.get("p1"))) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1") + ":" + "AS Result Error");
      }
      // KR-OHK Serial check add end

      logPram.put("P_RESULT_TYPE", "AS");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));
      ///////////////////////// LOGISTIC SP CALL END //////////////////////

      String mobileYn = params.get("mobileYn") == null ? "" :params.get("mobileYn").toString();
      LOGGER.debug("mobileYn ====>> " + mobileYn);
      LOGGER.debug("chkInstallAcc ====>> " +  CommonUtils.nvl(params.get("chkInstallAcc")));

//      if (params.get("mobileYn").toString() == "Y") { // from mobile
	  if (mobileYn == "Y") { // from mobile

          List<String> installAccList = (List<String>) svc0004dmap.get("instAccLst");
          EgovMap installResult = new EgovMap();

          installResult.put("asEntryNo", svc0004dmap.get("AS_RESULT_NO"));
          installResult.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
          installResult.put("mobileYn", mobileYn);
          installResult.put("chkInstallAcc", CommonUtils.nvl(params.get("chkInstallAcc")));
          //params.put("chkInstallAcc", svc0004dmap.get("INS_ACC_CHK"));
          params.put("asEntryId", svc0004dmap.get("AS_ENTRY_ID"));
          params.put("user_id", params.get("updator"));

          LOGGER.debug("chkInstallAcc flag 2====" + installResult.get("chkInstallAcc").toString());

          if ( installResult.get("chkInstallAcc").toString() == "Y" || installResult.get("chkInstallAcc").toString().equals("Y") ){
              try {
                insertInstallationAccessories(installAccList,installResult,CommonUtils.intNvl(params.get("updator")));
              } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
              }
              }
       }else {
    	  // // Insert SVC0140D for Installation Accessory - TPY
      List<String> installAccList = (List<String>) params.get("installAccList");
      EgovMap installResult = new EgovMap();

      installResult.put("asEntryNo", svc0004dmap.get("AS_RESULT_NO"));
      installResult.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
      installResult.put("mobileYn", params.get("mobileYn"));
      params.put("chkInstallAcc", svc0004dmap.get("INS_ACC_CHK"));
      params.put("asEntryId", svc0004dmap.get("AS_ENTRY_ID"));
      params.put("user_id", params.get("updator"));

      // disable old installation accessories
      ASManagementListMapper.disbleInstallAccWithAsEntryId(params);
      if (params.get("chkInstallAcc") != null && (params.get("chkInstallAcc").toString().equals("on") || params.get("chkInstallAcc").toString().equals("Y"))){
        try {
          insertInstallationAccessories(installAccList,installResult,CommonUtils.intNvl(params.get("updator")));
        } catch (Exception e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
        }
      }
    }
  }
    // LOGISTIC REQUEST END HERE

    EgovMap em = new EgovMap();
    em.put("AS_NO", String.valueOf(eMap.get("asno")));
    em.put("SP_MAP", logPram);

    if (String.valueOf(svc0004dmap.get("AS_RESULT_STUS_ID")).equals("19")) { // RECALL
      Map<String, Object> rclLog = new HashMap<String, Object>();

      rclLog.put("AS_ID", svc0004dmap.get("AS_ENTRY_ID"));
      rclLog.put("USER_ID", String.valueOf(svc0004dmap.get("updator")));
      rclLog.put("CALL_STUS_ID", "40");
      rclLog.put("CALL_FDBCK_ID", "0");
      rclLog.put("CALL_REM", svc0004dmap.get("AS_RCL_RMK"));
      rclLog.put("CALL_HC_ID", "0");
      rclLog.put("CALL_ROS_AMT", "0");
      rclLog.put("CALL_SMS", "0");
      rclLog.put("CALL_SMS_REM", "");

      int rtnValue = this.addASRemark(rclLog);

      Map<String, Object> rclUpdASEntry = new HashMap<String, Object>();
      rclUpdASEntry.put("AS_ID", svc0004dmap.get("AS_ENTRY_ID"));
      rclUpdASEntry.put("AS_APP_DT", svc0004dmap.get("AS_APP_DT"));
      rclUpdASEntry.put("AS_APP_SESS", svc0004dmap.get("AS_APP_SESS"));
      rclUpdASEntry.put("AS_RCL_ASG_DSC", svc0004dmap.get("AS_RCL_ASG_DSC"));
      rclUpdASEntry.put("AS_MEM_ID", svc0004dmap.get("AS_RCL_ASG_CT"));
      rclUpdASEntry.put("AS_MEM_GRP", svc0004dmap.get("AS_RCL_ASG_CT_GRP"));
      rclUpdASEntry.put("SEGMENT_TYPE", svc0004dmap.get("SEGMENT_TYPE"));

      int a = ASManagementListMapper.updateSVC0001D_RCL(rclUpdASEntry);
    }

    List<EgovMap> DefectTypSCList = ASManagementListMapper
        .getDefectTypSCList(svc0004dmap.get("AS_SLUTN_RESN_ID").toString());
    // HERE INSERT NEW IN HOUSE DATA.
    LOGGER.debug("= PARAMS {}" + params);
    if (String.valueOf(svc0004dmap.get("AS_RESULT_STUS_ID")).equals("4")) {
      // if (String.valueOf(svc0004dmap.get("AS_SLUTN_RESN_ID")).equals("454") || String.valueOf(svc0004dmap.get("AS_SLUTN_RESN_ID")).equals("7018") ) {
      LOGGER.debug("================   DefectTypSCList : " + DefectTypSCList + "   svc0004dmap : " + svc0004dmap);
      boolean DefectList = DefectTypSCList.isEmpty();
      if (DefectList != true) {
        params.put("AS_SO_ID", svc0004dmap.get("AS_SO_ID"));
        this.saveASEntryInHouse(params);
      }
    }

    //LOGGER.debug("================TEMP YONG FOR DEV/LOCAL DEBUG HARDCODE - START ================");
    //svc0004dmap.put("AS_CT_CODE", "CT100676");
    //svc0004dmap.put("TEL_M", "0165666878");
    //LOGGER.debug("================TEMP YONG FOR DEV/LOCAL DEBUG HARDCODE - END ================");

    //LOGGER.debug("================TEMP YONG FOR DEV/LOCAL DEBUG - START ================");
    //LOGGER.debug("PARAMS BY YONG:" + svc0004dmap.toString());
    //LOGGER.debug("CHECKPOINT BY YONG - get AS_CT_CODE:" + svc0004dmap.get("AS_CT_CODE"));
    //LOGGER.debug("CHECKPOINT BY YONG - get TEL_M:" + svc0004dmap.get("TEL_M").toString());
    //LOGGER.debug("================TEMP YONG FOR DEV/LOCAL DEBUG - END ================");

    if (String.valueOf(svc0004dmap.get("AS_CT_CODE")).equals("") || String.valueOf(svc0004dmap.get("AS_CT_CODE")) == null || String.valueOf(svc0004dmap.get("AS_CT_CODE")).equals("null")) { // This is to capture userId from Apps
    	svc0004dmap.put("AS_CT_CODE", String.valueOf(svc0004dmap.get("userId")));
    }

    if (String.valueOf(svc0004dmap.get("TEL_M")).equals("") || String.valueOf(svc0004dmap.get("TEL_M")) == null || String.valueOf(svc0004dmap.get("TEL_M")).equals("null")) { // This is to capture resultIcMobileNo from Apps
    	svc0004dmap.put("TEL_M", String.valueOf(svc0004dmap.get("resultIcMobileNo")));
    }


    /*LOGGER.debug("================TEMP YONG FOR DEV/LOCAL DEBUG - START ================");
    LOGGER.debug("PARAMS BY YONG:" + svc0004dmap.toString());
    LOGGER.debug("CHECKPOINT BY YONG - get AS_CT_CODE:" + svc0004dmap.get("AS_CT_CODE"));
    LOGGER.debug("CHECKPOINT BY YONG - get TEL_M:" + svc0004dmap.get("TEL_M").toString());
    LOGGER.debug("================TEMP YONG FOR DEV/LOCAL DEBUG - END ================");

 // INSERT SMS FOR APPOINTMENT - KAHKIT - 2021/11/29 -- 674,2703
    String smsMessage = "";
    if(String.valueOf(svc0004dmap.get("AS_RESULT_STUS_ID")).equals("4") &&
      ( String.valueOf(svc0004dmap.get("AS_MALFUNC_ID")).equals("9001600") || String.valueOf(svc0004dmap.get("AS_MALFUNC_ID")).equals("9001500") || String.valueOf(svc0004dmap.get("AS_MALFUNC_ID")).equals("9001200")) || String.valueOf(svc0004dmap.get("AS_MALFUNC_ID")).equals("9001800") || String.valueOf(svc0004dmap.get("AS_MALFUNC_ID")).equals("9001400")){
      smsMessage = "COWAY:Dear Customer, Your After Service is completed by "+ svc0004dmap.get("AS_CT_CODE") +" on " + svc0004dmap.get("AS_SETL_DT").toString() + ". Pls fill in survey : https://bit.ly/CowaySVC";
    }else if(String.valueOf(svc0004dmap.get("AS_RESULT_STUS_ID")).equals("10")){
      smsMessage = "COWAY:Dear Customer, Your Appointment for After Service has failed due to "+ svc0004dmap.get("AS_FAIL_RESN_DESC").toString() +".Will call to set new appointment.";
    }
    Map<String, Object> smsList = new HashMap<>();
    smsList.put("userId", String.valueOf(svc0004dmap.get("updator")));
    smsList.put("smsType", 975);
    smsList.put("smsMessage", smsMessage);
    smsList.put("smsMobileNo", svc0004dmap.get("TEL_M").toString());

    if(smsMessage != "")
    {
    	sendSms(smsList);
    }*/

    LOGGER.debug("================asResult_insert - END ================");
    return em;
  }

  @Override
  public int saveASEntryInHouse(Map<String, Object> params) {
    params.put("REF_REQUEST", (String) ((Map) params.get("asResultM")).get("AS_ENTRY_ID")); // REFER ID

    params.put("DOCNO", "169");
    EgovMap eMap = ASManagementListMapper.getASEntryDocNo(params); // GET NEW AS NO

    EgovMap seqMap = ASManagementListMapper.getIHREntryId(params); // GET NEW AS ENTRY NO
    EgovMap ccrSeqMap = ASManagementListMapper.getCCR0006D_CALL_ENTRY_ID_SEQ(params);

    params.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    params.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    params.put("AS_CALLLOG_ID", String.valueOf(ccrSeqMap.get("seq")).trim());

    int a = ASManagementListMapper.insertSVC0108D(params);
    // int b = 0;

    // 콜로그생성
    int c6d = ASManagementListMapper.insertCCR0006D(setCCR000Data(params));
    int c7d = ASManagementListMapper.insertCCR0007D(setCCR000Data(params));

    // String PIC_NAME = String.valueOf(params.get("PIC_NAME"));
    // String PIC_CNTC = String.valueOf(params.get("PIC_CNTC"));

    // f (PIC_NAME.length() > 0 || PIC_CNTC.length() > 0) {
    // b = ASManagementListMapper.insertSVC0003D(params);
    // }

    // RAS 상태 업데이트
    // if ("RAS".equals(params.get("ISRAS"))) {
    // HashMap<Object, String> rasMap = new HashMap<Object, String>();
    // rasMap.put("AS_ENTRY_ID", ARS_AS_ID);
    // rasMap.put("USER_ID", String.valueOf(params.get("updator")));
    // rasMap.put("AS_RESULT_STUS_ID", "4");
    // ASManagementListMapper.updateStateSVC0001D(params);
    // }

    return a;
  }

  @Override
  public EgovMap asResult_update_1(Map<String, Object> params) {
    // AS'S EDIT RESULT
    ArrayList<AsResultChargesViewVO> vewList = null;
    List<EgovMap> addItemList = null;
    List<EgovMap> resultMList = null;

    LinkedHashMap svc0004dmap = null;
    EgovMap seqpay17Map = null;
    EgovMap eASEntryDocNo = null;
    EgovMap asResultASEntryId = null;
    EgovMap invoiceDocNo = null;

    String ACC_INV_VOID_ID = null;
    String NEW_AS_RESULT_ID = null;
    String NEW_AS_RESULT_NO = null;

    double asTotAmt = 0;

    svc0004dmap = (LinkedHashMap) params.get("asResultM");

    String AS_ID = String.valueOf(svc0004dmap.get("AS_ID"));
    String ACC_BILL_ID = String.valueOf(svc0004dmap.get("ACC_BILL_ID"));
    String ACC_INVOICE_NO = String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) != ""
        ? String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) : String.valueOf(svc0004dmap.get("AS_RESULT_NO"));
    params.put("ACC_BILL_ID", ACC_BILL_ID);
    params.put("ACC_INVOICE_NO", ACC_INVOICE_NO);

    seqpay17Map = ASManagementListMapper.getPAY0017SEQ(params);
    ACC_INV_VOID_ID = String.valueOf(seqpay17Map.get("seq"));
    params.put("ACC_INV_VOID_ID", ACC_INV_VOID_ID);

    params.put("DOCNO", "21");
    eASEntryDocNo = ASManagementListMapper.getASEntryDocNo(params);
    asResultASEntryId = ASManagementListMapper.getResultASEntryId(params);

    NEW_AS_RESULT_ID = String.valueOf(asResultASEntryId.get("seq"));
    NEW_AS_RESULT_NO = String.valueOf(eASEntryDocNo.get("asno"));

    svc0004dmap.put("NEW_AS_RESULT_ID", NEW_AS_RESULT_ID);
    svc0004dmap.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);
    svc0004dmap.put("updator", params.get("updator"));

    vewList = new ArrayList<AsResultChargesViewVO>();
    addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);

    // GET LATEST SVC0004D RECORD
    resultMList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

    EgovMap emp = (EgovMap) resultMList.get(0);
    svc0004dmap.put("AS_RESULT_ID", String.valueOf(emp.get("asResultId")));
    svc0004dmap.put("AS_RESULT_NO", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
    asTotAmt = Double.parseDouble(String.valueOf(((EgovMap) resultMList.get(0)).get("asTotAmt")));

    LOGGER.debug("== OLD SVC0004D'S RECORD : " + resultMList.toString());
    LOGGER.debug("== OLD TOTAL AMOUNT : " + asTotAmt);

    // REVERSE SVC0004D
    svc0004dmap.put("OLD_AS_RESULT_ID", svc0004dmap.get("AS_RESULT_ID"));
    int reverse_SVC0004D_cnt = ASManagementListMapper.reverse_SVC0004D(svc0004dmap); // INSERT REVERSE SVC0004D
    int reverse_CURR_SVC0004D_cnt = ASManagementListMapper.reverse_CURR_SVC0004D(svc0004dmap); // UPDATE OLD ISCUR COLUMN TO 0 MAKE IT NOT THE LATEST RECORD
    int reverse_SVC0005D_cnt = ASManagementListMapper.reverse_CURR_SVC0005D(svc0004dmap); // INSERT REVERSE SVC0005D
    // INSERT REVERSE USED FILTER
    int reverse_LOG0103M_cnt = ASManagementListMapper.reverse_CURR_LOG0103M(svc0004dmap); // INSERT REVERSE SVC0005D

    // REVERSE LOGISTIC CALL
    Map<String, Object> logPram = null;
    logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", NEW_AS_RESULT_ID);
    logPram.put("RETYPE", "RETYPE");
    logPram.put("P_TYPE", "OD04");
    logPram.put("P_PRGNM", "ASCEN");
    logPram.put("USERID", String.valueOf(svc0004dmap.get("updator")));

    Map SRMap = new HashMap();
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE(logPram);
    LOGGER.debug("== RESULT CALL SP_LOGISTIC_REQUEST_REVERSE : " + logPram.toString());

    // ADD NEW AS RESULT
    EgovMap cm = ASManagementListMapper.getLog0016DCount(svc0004dmap);
    int log0016dCnt = Integer.parseInt(String.valueOf(cm.get("cnt")));

    // AUTO REQUEST PDO (IF CURRENT RESULT HAS COMPLETE PDO CLAIM)
    if (log0016dCnt > 0) {
      LOGGER.debug("== START REQUEST PDO - START ==");
      EgovMap PDO_DocNoMap = null;
      EgovMap LOG_IDMap = null;
      String PDO_DocNo = null;
      String LOG16_ID = null;

      params.put("DOCNO", "26");
      PDO_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      PDO_DocNo = String.valueOf(PDO_DocNoMap.get("asno"));

      LOG_IDMap = ASManagementListMapper.getLOG0015DSEQ(params);
      LOG16_ID = String.valueOf(LOG_IDMap.get("seq"));

      svc0004dmap.put("STK_REQ_ID", LOG16_ID);
      svc0004dmap.put("STK_REQ_NO", PDO_DocNo);

      int a = ASManagementListMapper.insert_LOG0015D(svc0004dmap);
      if (a > 0) {
        int insert_LOG0016D_cnt = ASManagementListMapper.insert_LOG0016D(svc0004dmap);
      }
      LOGGER.debug("== START REQUEST PDO - END ==");
    }

    // Reverse InvStkRecordCard (Return Stock To Member's Hand) -- Prepare for
    // PDO return (ACF)
    // ~~~~~~~~~~~~~ 수정필요 SEELECT 후 INSERT 처리 하자. ......
    // ASManagementListMapper.insert_LOG0014D(svc0004dmap); 꼭 주석 ㅜ

//    // CN Waive Billing (If Current Result has charge)
    if (asTotAmt > 0) {
      ASManagementListMapper.reverse_PAY0007D(svc0004dmap);

      svc0004dmap.put("ACC_BILL_ID", svc0004dmap.get("ACC_BILL_ID"));
      List<EgovMap> resultPAY0016DList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

      EgovMap pay0016dData = null;
      if (null != resultPAY0016DList) {
        int reverse_updatePAY0016D_cnt = ASManagementListMapper.reverse_updatePAY0016D(svc0004dmap);
      }

      pay0016dData = (EgovMap) ASManagementListMapper.getResult_PAY0016D(svc0004dmap);
//
      EgovMap CN_DocNoMap = null;
      String CNNO = null;

      EgovMap CNReportNo_DocNoMap = null;
      String CNReportNo = null;

      params.put("DOCNO", "134");
      CN_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      CNNO = String.valueOf(CN_DocNoMap.get("asno"));

      params.put("DOCNO", "18");
      CNReportNo_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      CNReportNo = String.valueOf(CNReportNo_DocNoMap.get("asno"));

      List<EgovMap> resultPAY0031DList = null;
      svc0004dmap.put("accBillRem", pay0016dData.get("accBillRem"));
      resultPAY0031DList = ASManagementListMapper.getResult_PAY0031D(svc0004dmap);
      EgovMap resultPAY0031DInfo = resultPAY0031DList.get(0);

      ////////////////// pay16d AccOrderBill ////////////////////
      EgovMap PAY0016DSEQMap = ASManagementListMapper.getPAY0016DSEQ(params);
      String PAY0016DSEQ = String.valueOf(PAY0016DSEQMap.get("seq"));
      EgovMap pay16d_insert = new EgovMap();
      pay16d_insert.put("memoAdjId", PAY0016DSEQ);
      pay16d_insert.put("memoAdjRefNo", CNNO);
      pay16d_insert.put("memoAdjRptNo", CNReportNo);
      pay16d_insert.put("memoAdjTypeId", "1293");
      pay16d_insert.put("memoAdjInvcNo", pay0016dData.get("accBillRem"));
      pay16d_insert.put("memoAdjInvcTypeId", "128");
      pay16d_insert.put("memoAdjStusId", "4");
      pay16d_insert.put("memoAdjResnId", "2038");
      pay16d_insert.put("memoAdjRem", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay16d_insert.put("memoAdjTxsAmt", resultPAY0031DInfo.get("taxInvcTxs"));
      pay16d_insert.put("memoAdjTotAmt", resultPAY0031DInfo.get("taxInvcAmtDue"));
      pay16d_insert.put("memoAdjCrtDt", new Date());
      pay16d_insert.put("memoAdjCrtUserId", svc0004dmap.get("updator"));
      pay16d_insert.put("memoAdjUpdDt", new Date());
      pay16d_insert.put("memoAdjUpdUserId", svc0004dmap.get("updator"));
      pay16d_insert.put("batchId", "");
      ASManagementListMapper.reverse_PAY0016D(pay16d_insert);
      ////////////////// ////////////////////

      ////////////////// AccInvoiceAdjustment_Sub ////////////////////
      svc0004dmap.put("MEMO_ADJ_ID", PAY0016DSEQ);
      svc0004dmap.put("MEMO_ITM_TAX_CODE_ID", pay0016dData.get("accBillTaxCodeId"));
      svc0004dmap.put("MEMO_ITM_REM", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
      svc0004dmap.put("TAX_INVC_REF_NO", pay0016dData.get("accBillRem"));
      int reverse_PAY0012D_cnt = ASManagementListMapper.reverse_PAY0012D(svc0004dmap);
      ////////////////// pay12d ////////////////////

      ////////////////// pay27d AccTaxDebitCreditNote ////////////////////
      EgovMap PAY0027DSEQMap = ASManagementListMapper.getPAY0027DSEQ(params);
      String PAY0027DSEQ = String.valueOf(PAY0027DSEQMap.get("seq"));
      EgovMap pay27d_insert = new EgovMap();
      pay27d_insert.put("noteId", PAY0027DSEQ);
      pay27d_insert.put("noteEntryId", PAY0016DSEQ);
      pay27d_insert.put("noteTypeId", "1293");
      pay27d_insert.put("noteGrpNo", resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay27d_insert.put("noteRefNo", CNNO);
      pay27d_insert.put("noteRefDt", resultPAY0031DInfo.get("taxInvcRefDt"));
      pay27d_insert.put("noteInvcNo", pay0016dData.get("accBillRem"));
      pay27d_insert.put("noteInvcTypeId", "128");
      pay27d_insert.put("noteCustName", resultPAY0031DInfo.get("taxInvcCustName"));
      pay27d_insert.put("noteCntcPerson", resultPAY0031DInfo.get("taxInvcCntcPerson"));
      pay27d_insert.put("noteAddr1", resultPAY0031DInfo.get("taxInvcAddr1"));
      pay27d_insert.put("noteAddr2", resultPAY0031DInfo.get("taxInvcAddr2"));
      pay27d_insert.put("noteAddr3", resultPAY0031DInfo.get("taxInvcAddr3"));
      pay27d_insert.put("noteAddr4", resultPAY0031DInfo.get("taxInvcAddr4"));
      pay27d_insert.put("notePostCode", resultPAY0031DInfo.get("taxInvcPostCode"));
      pay27d_insert.put("noteAreaName", "");
      pay27d_insert.put("noteStateName", resultPAY0031DInfo.get("taxInvcStateName"));
      pay27d_insert.put("noteCntyName", resultPAY0031DInfo.get("taxInvcCnty"));
      pay27d_insert.put("noteTxs", resultPAY0031DInfo.get("taxInvcTxs"));
      pay27d_insert.put("noteChrg", resultPAY0031DInfo.get("taxInvcChrg"));
      pay27d_insert.put("noteAmtDue", resultPAY0031DInfo.get("taxInvcAmtDue"));
      pay27d_insert.put("noteRem", "AS RESULT REVERSAL - " + resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay27d_insert.put("noteStusId", "4");
      pay27d_insert.put("noteCrtDt", new Date());
      pay27d_insert.put("noteCrtUserId", svc0004dmap.get("updator"));
      ASManagementListMapper.reverse_PAY0027D(pay27d_insert);
      ////////////////// pay27d end ////////////////////

      ////////// AccTaxDebitCreditNote_Sub ////////////
      if (reverse_PAY0012D_cnt > 0) {
        svc0004dmap.put("NOTE_ID", PAY0027DSEQ);
        int reverse_PAY0028D_cnt = ASManagementListMapper.reverse_PAY0028D(svc0004dmap);
      }

      ////////////////// pay17d pay18d ////////////////////
      EgovMap PAY0017DSEQMap = ASManagementListMapper.getPAY0017DSEQ(params);
      String PAY0017DSEQ = String.valueOf(PAY0017DSEQMap.get("seq"));
      svc0004dmap.put("ACC_INV_VOID_ID", PAY0017DSEQ);
      svc0004dmap.put("accInvVoidSubCrditNoteId", PAY0016DSEQ);
      svc0004dmap.put("accInvVoidSubCrditNote", CNNO);
      setPay17dData(svc0004dmap);
      setPay18dData(svc0004dmap);
      ////////////////// pay17d pay18d end////////////////////

      ////////////////// pay06d ////////////////////
      EgovMap pay06d_insert = new EgovMap();
      pay06d_insert.put("asId", AS_ID);
      pay06d_insert.put("asDocNo", CNNO);
      pay06d_insert.put("asLgDocTypeId", "155");
      pay06d_insert.put("asLgDt", new Date());
      pay06d_insert.put("asLgAmt", (((BigDecimal) resultPAY0031DInfo.get("taxInvcAmtDue")).negate()));
      pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
      pay06d_insert.put("asLgUpdDt", new Date());
      pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
      pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
      pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
      pay06d_insert.put("asAdvPay", "0");
      pay06d_insert.put("r01", "");
      // 4
      int reverse_PAY0006D_cnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
      ////////////////// pay06d end////////////////////
    }
//
//    ////////////////// pay06d ////////////////////
//    /// Restore Advanced AS Payment Use In Current Result
//    List<EgovMap> p6dList = ASManagementListMapper.getResult_PAY0006D(svc0004dmap);
//    if (null != p6dList && p6dList.size() > 0) {
//      for (int i = 0; i < p6dList.size(); i++) {
//        EgovMap pay06d_insert = p6dList.get(i);
//
//        ////////////////// pay06d 1set ////////////////////
//        BigDecimal asLgAmt = (BigDecimal) pay06d_insert.get("asLgAmt");
//        // double p16d_asTotAmt = pay06d_insert.get("asLgAmt") ==null ? 0 :
//        // Double.parseDouble((String)pay06d_insert.get("asLgAmt") );
//        long p16d_asTotAmt = pay06d_insert.get("asLgAmt") == null ? 0 : asLgAmt.longValue();
//
//        pay06d_insert.put("asId", AS_ID);
//        pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
//        pay06d_insert.put("asLgDocTypeId", "163");
//        pay06d_insert.put("asLgDt", new Date());
//        pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
//        pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//        pay06d_insert.put("asLgUpdDt", new Date());
//        pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
//        pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
//        pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
//        pay06d_insert.put("asAdvPay", "1");
//        pay06d_insert.put("r01", "");
//        // 3
//        int reverse_PAY0006D_1setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
//        ////////////////// pay06d 1set end////////////////
//
//        ////////////////// pay06d 2set ////////////////////
//        pay06d_insert.put("asId", AS_ID);
//        pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
//        pay06d_insert.put("asLgDocTypeId", "401");
//        pay06d_insert.put("asLgDt", new Date());
//        pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
//        pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//        pay06d_insert.put("asLgUpdDt", new Date());
//        pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
//        pay06d_insert.put("asResultNo", "");
//        pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
//        pay06d_insert.put("asAdvPay", "1");
//        pay06d_insert.put("r01", "");
//        // 2
//        int reverse_PAY0006D_2setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
//        ////////////////// pay06d 2set end////////////////
//      }
//    }
//    ////////////////// pay06d end ////////////////////
//
//    // Reverse All AS Payment Transaction Including Reverse Payment,because
//    // reverse payment can be partial amount
//    List<EgovMap> p7dList = ASManagementListMapper.getResult_PAY0007D(svc0004dmap);
//    if (null != p7dList && p7dList.size() > 0) {
//
//      ////////////////// pay07d update ////////////////
//      int reverse_StateUpPAY0007D_cnt = ASManagementListMapper.reverse_StateUpPAY0007D(svc0004dmap);
//      ////////////////// pay07d update ////////////////
//
//      ////////////////// PAY0064D SELECT ////////////////
//
//      svc0004dmap.put("BILL_ID", String.valueOf((p7dList.get(0)).get("billId")));
//      List<EgovMap> p64dList = ASManagementListMapper.getResult_PAY0064D(svc0004dmap);
//      ////////////////// PAY0064D ////////////////
//      if (null != p64dList && p64dList.size() > 0) {
//        for (int i = 0; i < p64dList.size(); i++) {
//
//          EgovMap p64dList_Map = p64dList.get(i);
//          BigDecimal totAmt = (BigDecimal) p64dList_Map.get("totAmt");
//          // double trxTotAmt = p64dList_Map.get("totAmt") ==null ? 0 :
//          // Double.parseDouble((String)p64dList_Map.get("totAmt") );
//          long trxTotAmt = p64dList_Map.get("totAmt") == null ? 0 : totAmt.longValue();
//          Map PAY_DocNoMap = null;
//          String PAYNO_REV = null;
//
//          params.put("DOCNO", "82");
//          PAY_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
//          PAYNO_REV = String.valueOf(PAY_DocNoMap.get("asno"));
//
//          EgovMap PAY0069DSEQMap = ASManagementListMapper.getPAY0069DSEQ(params);
//          String PAY0069DSEQ = String.valueOf(PAY0069DSEQMap.get("seq"));
//
//          ////////////////// PAY0069D insert ////////////////
//          EgovMap pay069d_insert = new EgovMap();
//          pay069d_insert.put("trxId", PAY0069DSEQ);
//          pay069d_insert.put("trxDt", new Date());
//          pay069d_insert.put("trxType", "101");
//          pay069d_insert.put("trxAmt", (-1 * trxTotAmt));
//          pay069d_insert.put("trxMtchNo", "");
//
//          int insert_PAY0069D_cnt = ASManagementListMapper.insert_PAY0069D(pay069d_insert);
//          ////////////////// PAY0069D out ////////////////
//
//          ////////////////// PAY0064D insert ////////////////
//          EgovMap PAY0064DSEQMap = ASManagementListMapper.getPAY0064DSEQ(params);
//          String PAY0064DSEQ = String.valueOf(PAY0064DSEQMap.get("seq"));
//
//          EgovMap pay064d_insert = new EgovMap();
//          pay064d_insert.put("payId", PAY0064DSEQ);
//          pay064d_insert.put("orNo", PAYNO_REV);
//          pay064d_insert.put("salesOrdId", p64dList_Map.get("salesOrdId"));
//          pay064d_insert.put("billId", p64dList_Map.get("billId"));
//          pay064d_insert.put("trNo", p64dList_Map.get("trNo"));
//          pay064d_insert.put("typeId", "101");
//          // pay064d_insert.put("payData",new Date());
//          pay064d_insert.put("bankChgAmt", p64dList_Map.get("bankChgAmt"));
//          pay064d_insert.put("bankChgAccId", p64dList_Map.get("bankChgAccId"));
//          pay064d_insert.put("collMemId", p64dList_Map.get("collMemId"));
//          pay064d_insert.put("brnchId", params.get("brnchId"));
//          pay064d_insert.put("bankAccId", p64dList_Map.get("bankAccId"));
//          pay064d_insert.put("allowComm", p64dList_Map.get("allowComm"));
//          pay064d_insert.put("stusCodeId", "1");
//          pay064d_insert.put("updUserId", svc0004dmap.get("updator"));
//          // pay064d_insert.put("updDt",new Date());
//          pay064d_insert.put("syncHeck", "0");
//          pay064d_insert.put("custId3party", p64dList_Map.get("custId3party"));
//          // double p46TotAmt = p64dList_Map.get("totAmt") ==null ? 0 :
//          // Double.parseDouble((String)p64dList_Map.get("totAmt") );
//          pay064d_insert.put("totAmt", (-1 * trxTotAmt)); // p46TotAmt
//          pay064d_insert.put("mtchId", p64dList_Map.get("payId"));
//          pay064d_insert.put("crtUserId", svc0004dmap.get("updator"));
//          // pay064d_insert.put("crtDt",new Date());
//          pay064d_insert.put("isAllowRevMulti", "0");
//          pay064d_insert.put("isGlPostClm", "0");
//          pay064d_insert.put("glPostClmDt", "01/01/1900");
//          pay064d_insert.put("trxId", PAY0069DSEQ);
//          pay064d_insert.put("advMonth", "0");
//          pay064d_insert.put("accBillId", "0");
//          pay064d_insert.put("trIssuDt", "01/01/1900");
//          pay064d_insert.put("taxInvcIsGen", "0");
//          pay064d_insert.put("taxInvcRefNo", "");
//          pay064d_insert.put("taxInvcRefDt", "01/01/1900");
//          pay064d_insert.put("svcCntrctId", "0");
//          pay064d_insert.put("batchPayId", "0");
//          int insert_PAY0064D_cnt = ASManagementListMapper.insert_PAY0064D(pay064d_insert);
//          ////////////////// PAY0064D out ////////////////
//
//          ////////////////// PAY0065D insert ////////////////
//          svc0004dmap.put("PAY_ID", PAY0064DSEQ);
//          List<EgovMap> p65dList = ASManagementListMapper.getResult_PAY0065D(svc0004dmap);
//          EgovMap PAY0065DSEQMap = ASManagementListMapper.getPAY0065DSEQ(params);
//          String PAY0065DSEQ = String.valueOf(PAY0065DSEQMap.get("seq"));
//
//          if (null != p65dList && p65dList.size() > 0) {
//            for (int a = 0; a < p65dList.size(); a++) {
//
//              // INSER PAY0065D
//              EgovMap p65dList_Map = p65dList.get(i);
//              // double payTotAmt = p65dList_Map.get("payItmAmt") ==null ? 0 :
//              // Double.parseDouble(((String)p65dList_Map.get("payItmAmt") ));
//
//              BigDecimal totAmt65D = (BigDecimal) p65dList_Map.get("totAmt");
//              long trxTotAmt65D = p65dList_Map.get("totAmt") == null ? 0 : totAmt65D.longValue();
//
//              EgovMap pay065d_insert = new EgovMap();
//              pay065d_insert.put("payItmId", PAY0065DSEQ);
//              pay065d_insert.put("payId", PAY0064DSEQ);
//              pay065d_insert.put("payItmModeId", p65dList_Map.get("payItmModeId"));
//              pay065d_insert.put("payItmRefNo", p65dList_Map.get("payItmRefNo"));
//              pay065d_insert.put("payItmCcNo", p65dList_Map.get("payItmCcNo"));
//              pay065d_insert.put("payItmOriCcNo", p65dList_Map.get("payItmOriCcNo"));
//              pay065d_insert.put("payItmEncryptCcNo", p65dList_Map.get("payItmEncryptCcNo"));
//              pay065d_insert.put("payItmCcTypeId", p65dList_Map.get("payItmCcTypeId"));
//              pay065d_insert.put("payItmChqNo", p65dList_Map.get("payItmChqNo"));
//              pay065d_insert.put("payItmIssuBankId", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmAmt", (-1 * trxTotAmt65D)); // payTotAmt
//              pay065d_insert.put("payItmIsOnline", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmBankAccId", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmRefDt", "01/01/1900");
//              pay065d_insert.put("payItmAppvNo", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmRem", "AS RESULT EDIT (REVERSE PAYMENT)");
//              pay065d_insert.put("payItmStusId", "1");
//              pay065d_insert.put("payItmIsLok", "0");
//              pay065d_insert.put("payItmCcHolderName", p65dList_Map.get("payItmCcHolderName"));
//              pay065d_insert.put("payItmCcExprDt", p65dList_Map.get("payItmCcExprDt"));
//              pay065d_insert.put("payItmBankChrgAmt", p65dList_Map.get("payItmBankChrgAmt"));
//              pay065d_insert.put("payItmIsThrdParty", p65dList_Map.get("payItmIsThrdParty"));
//              pay065d_insert.put("payItmThrdPartyIc", p65dList_Map.get("payItmThrdPartyIc"));
//              pay065d_insert.put("payItmRefItmId", p65dList_Map.get("payItmId"));
//              pay065d_insert.put("skipRecon", "0");
//
//              pay065d_insert.put("payItmBankBrnchId", "0");
//              pay065d_insert.put("payItmBankInSlipNo", "0");
//              pay065d_insert.put("payItmEftNo", "0");
//              pay065d_insert.put("payItmChqDepReciptNo", "0");
//              pay065d_insert.put("etc1", "0");
//              pay065d_insert.put("etc2", "0");
//              pay065d_insert.put("etc3", "0");
//              pay065d_insert.put("payItmGrpId", "0");
//              pay065d_insert.put("payItmBankChrgAccId", "0");
//              pay065d_insert.put("updUserId", "0");
//              pay065d_insert.put("updDt", "");
//              pay065d_insert.put("isFundTrnsfr", "0");
//              pay065d_insert.put("payItmCardTypeId", "0");
//              pay065d_insert.put("payItmCardModeId", "0");
//              pay065d_insert.put("payItmRunngNo", "");
//              pay065d_insert.put("payItmMid", "");
//
//              int insert_PAY0065D_cnt = ASManagementListMapper.insert_PAY0065D(pay065d_insert);
//
//              // INSERT PAY0009D
//              EgovMap pay09d_insert = new EgovMap();
//              pay09d_insert.put("glPostngDt", new Date());
//              pay09d_insert.put("glFiscalDt", "01/01/1900");
//              pay09d_insert.put("glBatchNo", PAY0064DSEQ);
//              pay09d_insert.put("glBatchTypeDesc", "");
//              pay09d_insert.put("glBatchTot", (-1 * trxTotAmt65D));
//              pay09d_insert.put("glReciptNo", PAYNO_REV);
//              pay09d_insert.put("glReciptTypeId", "101");
//              pay09d_insert.put("glReciptBrnchId", svc0004dmap.get("brnchId"));
//
//              if ("107".equals(p65dList_Map.get("payItmModeId"))) { // ConvertTempAccountToSettlementAccount
//                int t_payItmIssuBankId = p65dList_Map.get("payItmIssuBankId") == null ? 0
//                    : Integer.parseInt((String) p65dList_Map.get("payItmIssuBankId"));
//                pay09d_insert.put("glReciptSetlAccId", this.convertTempAccountToSettlementAccount(t_payItmIssuBankId));
//                pay09d_insert.put("glReciptAccId", p65dList_Map.get("payItmIssuBankId"));
//
//              } else {
//                int t_payItmModeId = p65dList_Map.get("payItmModeId") == null ? 0
//                    : Integer.parseInt((String) p65dList_Map.get("payItmModeId"));
//                pay09d_insert.put("glReciptAccId", this.convertAccountToTempBasedOnPayMode(t_payItmModeId)); // ConvertAccountToTempBasedOnPayMode
//                pay09d_insert.put("glReciptSetlAccId", "0");
//              }
//
//              pay09d_insert.put("glReciptItmId", PAY0065DSEQ);
//              pay09d_insert.put("glReciptItmModeId", p65dList_Map.get("payItmModeId"));
//              pay09d_insert.put("glRevrsReciptItmId", p65dList_Map.get("payItmId"));
//              pay09d_insert.put("glReciptItmAmt", (-1 * trxTotAmt65D));
//
//              double t_payItemBankChargeAmt = p65dList_Map.get("payItmBankChrgAmt") == null ? 0
//                  : Double.parseDouble(((String) p65dList_Map.get("payItmBankChrgAmt")));
//              pay09d_insert.put("glReciptItmChrg", t_payItemBankChargeAmt);
//              pay09d_insert.put("glReciptItmRclStus", "N");
//              pay09d_insert.put("glJrnlNo", "");
//              pay09d_insert.put("glAuditRef", "");
//              pay09d_insert.put("glCnvrStus", "Y");
//              pay09d_insert.put("glCnvrDt", "");
//              int insert_PAY0009D_cnt = ASManagementListMapper.insert_PAY0009D(pay09d_insert);
//            }
//          }
//
//          // INSERT PAY0006D
//          svc0004dmap.put("AS_DOC_NO", String.valueOf(p64dList_Map.get("orNo")));
//          List<EgovMap> p06dList = ASManagementListMapper.getResult_DocNo_PAY0006D(svc0004dmap);
//
//          if (null != p06dList && p06dList.size() > 0) {
//            for (int a = 0; a < p06dList.size(); a++) {
//
//              EgovMap p06dList_Map = p06dList.get(a);
//              // double asLgAmt = p06dList_Map.get("asLgAmt") ==null ? 0 :
//              // Double.parseDouble(((String)p06dList_Map.get("asLgAmt") ));
//
//              BigDecimal totAmt06D = (BigDecimal) p06dList_Map.get("totAmt");
//              long trxTotAmt06D = p06dList_Map.get("totAmt") == null ? 0 : totAmt06D.longValue();
//
//              EgovMap pay06d_insert = new EgovMap();
//
//              pay06d_insert.put("asId", AS_ID);
//              pay06d_insert.put("asDocNo", PAYNO_REV);
//              pay06d_insert.put("asLgDocTypeId", "160");
//              pay06d_insert.put("asLgDt", new Date());
//              pay06d_insert.put("asLgAmt", (trxTotAmt06D * -1)); // asLgAmt
//              pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//              pay06d_insert.put("asLgUpdDt", new Date());
//              pay06d_insert.put("asSoNo", p06dList_Map.get("asSoNo"));
//              pay06d_insert.put("asResultNo", p06dList_Map.get("asSoNo"));
//              pay06d_insert.put("asSoId", p06dList_Map.get("asSoId"));
//              pay06d_insert.put("asAdvPay", p06dList_Map.get("asAdvPay"));
//              pay06d_insert.put("r01", "");
//              // 1
//              int reverse_PAY0006D_cnt = ASManagementListMapper.reverse_DocNo_PAY0006D(pay06d_insert);
//
//            }
//          }
//        }
//      }
//    }

    // REVERSE HAPPY CALL
    svc0004dmap.put("HC_TYPE_NO", svc0004dmap.get("AS_NO"));
    int reverse_State_CCR0001D_cnt = ASManagementListMapper.reverse_State_CCR0001D(svc0004dmap);

    // UNMAP PAYMENT
    if (ASManagementListMapper.chkPmtMap(svc0004dmap) >= 1) {
      LOGGER.debug(" =================== START TO UNMAP PAYMENT =================== ");
      // PAYMENT HAD MAPPED.
      // INSERT BACKUP
      LOGGER.debug(" =================== 1. BACKUP =================== ");
      ASManagementListMapper.bckupPAY0252T(svc0004dmap);
      // REMOVE DATA
      LOGGER.debug(" =================== 2. REMOVE =================== ");
      // ASManagementListMapper.rmvPAY0252T(svc0004dmap);
      // UPDATE STATUS
      LOGGER.debug(" =================== 3. UPDATE =================== ");
      ASManagementListMapper.updPAY0081D(svc0004dmap);
      LOGGER.debug(" =================== END TO UNMAP PAYMENT =================== ");
    }

    // REINSERT
    ((Map) params.get("asResultM")).put("AUTOINSERT", "TRUE");// hash
    EgovMap returnemp = this.asResult_insert(params);
    returnemp.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);

    return returnemp;
  }

  @Override
  public EgovMap asResult_update(Map<String, Object> params) {

    LOGGER.debug("==========asResult_update  Log  in================");

    ArrayList<AsResultChargesViewVO> vewList = null;
    List<EgovMap> addItemList = null;
    List<EgovMap> resultMList = null;

    LinkedHashMap svc0004dmap = null;
    EgovMap seqpay17Map = null;
    EgovMap eASEntryDocNo = null;
    EgovMap asResultASEntryId = null;
    EgovMap invoiceDocNo = null;

    String ACC_INV_VOID_ID = null;
    String NEW_AS_RESULT_ID = null;
    String NEW_AS_RESULT_NO = null;

    int asTotAmt = 0;

    svc0004dmap = (LinkedHashMap) params.get("asResultM");

    String AS_ID = String.valueOf(svc0004dmap.get("AS_ID"));
    String ACC_BILL_ID = String.valueOf(svc0004dmap.get("ACC_BILL_ID"));
    String ACC_INVOICE_NO = String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) != ""
        ? String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) : String.valueOf(svc0004dmap.get("AS_RESULT_NO"));
    params.put("ACC_BILL_ID", ACC_BILL_ID);
    params.put("ACC_INVOICE_NO", ACC_INVOICE_NO);

    seqpay17Map = ASManagementListMapper.getPAY0017SEQ(params);
    ACC_INV_VOID_ID = String.valueOf(seqpay17Map.get("seq"));
    params.put("ACC_INV_VOID_ID", ACC_INV_VOID_ID);

    params.put("DOCNO", "21");
    eASEntryDocNo = ASManagementListMapper.getASEntryDocNo(params);
    asResultASEntryId = ASManagementListMapper.getResultASEntryId(params);

    NEW_AS_RESULT_ID = String.valueOf(asResultASEntryId.get("seq"));
    NEW_AS_RESULT_NO = String.valueOf(eASEntryDocNo.get("asno"));

    svc0004dmap.put("NEW_AS_RESULT_ID", NEW_AS_RESULT_ID);
    svc0004dmap.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);
    svc0004dmap.put("updator", params.get("updator"));

    vewList = new ArrayList<AsResultChargesViewVO>();
    addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);

    resultMList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

    EgovMap emp = (EgovMap) resultMList.get(0);
    svc0004dmap.put("AS_RESULT_ID", String.valueOf(emp.get("asResultId")));
    svc0004dmap.put("AS_RESULT_NO", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
    asTotAmt = Integer.parseInt(String.valueOf(((EgovMap) resultMList.get(0)).get("asTotAmt")));

    LOGGER.debug("OLD SVC0004D==>[" + resultMList + "]");
    LOGGER.debug("==========asTotAmt ==> [" + asTotAmt + "]");

    // reverse_SVC0004D
    svc0004dmap.put("OLD_AS_RESULT_ID", svc0004dmap.get("AS_RESULT_ID"));
    int reverse_SVC0004D_cnt = ASManagementListMapper.reverse_SVC0004D(svc0004dmap);
    int reverse_CURR_SVC0004D_cnt = ASManagementListMapper.reverse_CURR_SVC0004D(svc0004dmap);
    int reverse_SVC0005D_cnt = ASManagementListMapper.reverse_CURR_SVC0005D(svc0004dmap);

    // 물류 reverse 호출 하기 ... OLD_AS_RESULT_ID로 호출

    ///////////////////////// 물류 호출/////////////////////////
    Map<String, Object> logPram = null;
    logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", NEW_AS_RESULT_ID);
    logPram.put("RETYPE", "RETYPE");
    logPram.put("P_TYPE", "OD04");
    logPram.put("P_PRGNM", "ASCEN");
    logPram.put("USERID", String.valueOf(svc0004dmap.get("updator")));

    Map SRMap = new HashMap();
    LOGGER.debug("ASManagementListServiceImpl.asResult_update in  CENCAL  물류 차감  PRAM ===>" + logPram.toString());
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE(logPram);
    LOGGER.debug("ASManagementListServiceImpl.asResult_update  in  CENCAL 물류 차감 결과   ===>" + logPram.toString());

    ////////////////// ADD NEW AS RESULT ////////////////

    EgovMap cm = ASManagementListMapper.getLog0016DCount(svc0004dmap);
    int log0016dCnt = Integer.parseInt(String.valueOf(cm.get("cnt")));

    // Auto Request PDO (If current result has complete PDO claim)
    if (log0016dCnt > 0) {

      EgovMap PDO_DocNoMap = null;
      EgovMap LOG_IDMap = null;
      String PDO_DocNo = null;
      String LOG16_ID = null;

      params.put("DOCNO", "26");
      PDO_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      PDO_DocNo = String.valueOf(PDO_DocNoMap.get("asno"));

      LOG_IDMap = ASManagementListMapper.getLOG0015DSEQ(params);
      LOG16_ID = String.valueOf(LOG_IDMap.get("seq"));

      svc0004dmap.put("STK_REQ_ID", LOG16_ID);
      svc0004dmap.put("STK_REQ_NO", PDO_DocNo);

      int a = ASManagementListMapper.insert_LOG0015D(svc0004dmap);
      if (a > 0) {
        int insert_LOG0016D_cnt = ASManagementListMapper.insert_LOG0016D(svc0004dmap);
      }
    }

    // Reverse InvStkRecordCard (Return Stock To Member's Hand) -- Prepare for
    // PDO return (ACF)

    // ~~~~~~~~~~~~~ 수정필요 SEELECT 후 INSERT 처리 하자. ......
    // ASManagementListMapper.insert_LOG0014D(svc0004dmap); 꼭 주석 ㅜ

//    // CN Waive Billing (If Current Result has charge)
    if (asTotAmt > 0) {
      // AccBillings
      ASManagementListMapper.reverse_PAY0007D(svc0004dmap);

      svc0004dmap.put("ACC_BILL_ID", svc0004dmap.get("ACC_BILL_ID"));
      List<EgovMap> resultPAY0016DList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

      EgovMap pay0016dData = null;
      if (null != resultPAY0016DList) {

        // AccOrderBill
        int reverse_updatePAY0016D_cnt = ASManagementListMapper.reverse_updatePAY0016D(svc0004dmap);
      }

      pay0016dData = (EgovMap) ASManagementListMapper.getResult_PAY0016D(svc0004dmap);

      EgovMap CN_DocNoMap = null;
      String CNNO = null;

      EgovMap CNReportNo_DocNoMap = null;
      String CNReportNo = null;

      params.put("DOCNO", "134");
      CN_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      CNNO = String.valueOf(CN_DocNoMap.get("asno"));

      params.put("DOCNO", "18");
      CNReportNo_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      CNReportNo = String.valueOf(CNReportNo_DocNoMap.get("asno"));

      List<EgovMap> resultPAY0031DList = null;
      svc0004dmap.put("accBillRem", pay0016dData.get("accBillRem"));
      resultPAY0031DList = ASManagementListMapper.getResult_PAY0031D(svc0004dmap);
      EgovMap resultPAY0031DInfo = resultPAY0031DList.get(0);

      ////////////////// pay16d ////////////////////
      EgovMap PAY0016DSEQMap = ASManagementListMapper.getPAY0016DSEQ(params);
      String PAY0016DSEQ = String.valueOf(PAY0016DSEQMap.get("seq"));
      EgovMap pay16d_insert = new EgovMap();
      pay16d_insert.put("memoAdjId", PAY0016DSEQ);
      pay16d_insert.put("memoAdjRefNo", CNNO);
      pay16d_insert.put("memoAdjRptNo", CNReportNo);
      pay16d_insert.put("memoAdjTypeId", "1293");
      pay16d_insert.put("memoAdjInvcNo", pay0016dData.get("accBillRem"));
      pay16d_insert.put("memoAdjInvcTypeId", "128");
      pay16d_insert.put("memoAdjStusId", "4");
      pay16d_insert.put("memoAdjResnId", "2038");
      pay16d_insert.put("memoAdjRem", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay16d_insert.put("memoAdjTxsAmt", resultPAY0031DInfo.get("taxInvcTxs"));
      pay16d_insert.put("memoAdjTotAmt", resultPAY0031DInfo.get("taxInvcAmtDue"));
      pay16d_insert.put("memoAdjCrtDt", new Date());
      pay16d_insert.put("memoAdjCrtUserId", svc0004dmap.get("updator"));
      pay16d_insert.put("memoAdjUpdDt", new Date());
      pay16d_insert.put("memoAdjUpdUserId", svc0004dmap.get("updator"));
      pay16d_insert.put("batchId", "");
      ASManagementListMapper.reverse_PAY0016D(pay16d_insert);
      ////////////////// pay12d ////////////////////

      ////////////////// pay12d ////////////////////
      svc0004dmap.put("MEMO_ADJ_ID", PAY0016DSEQ);
      svc0004dmap.put("MEMO_ITM_TAX_CODE_ID", pay0016dData.get("accBillTaxCodeId"));
      svc0004dmap.put("MEMO_ITM_REM", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
      svc0004dmap.put("TAX_INVC_REF_NO", pay0016dData.get("accBillRem"));
      int reverse_PAY0012D_cnt = ASManagementListMapper.reverse_PAY0012D(svc0004dmap);
      ////////////////// pay12d ////////////////////

      ////////////////// pay27d ////////////////////
      EgovMap PAY0027DSEQMap = ASManagementListMapper.getPAY0027DSEQ(params);
      String PAY0027DSEQ = String.valueOf(PAY0027DSEQMap.get("seq"));
      EgovMap pay27d_insert = new EgovMap();
      pay27d_insert.put("noteId", PAY0027DSEQ);
      pay27d_insert.put("noteEntryId", PAY0016DSEQ);
      pay27d_insert.put("noteTypeId", "1293");
      pay27d_insert.put("noteGrpNo", resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay27d_insert.put("noteRefNo", CNNO);
      pay27d_insert.put("noteRefDt", resultPAY0031DInfo.get("taxInvcRefDt"));
      pay27d_insert.put("noteInvcNo", pay0016dData.get("accBillRem"));
      pay27d_insert.put("noteInvcTypeId", "128");
      pay27d_insert.put("noteCustName", resultPAY0031DInfo.get("taxInvcCustName"));
      pay27d_insert.put("noteCntcPerson", resultPAY0031DInfo.get("taxInvcCntcPerson"));
      pay27d_insert.put("noteAddr1", resultPAY0031DInfo.get("taxInvcAddr1"));
      pay27d_insert.put("noteAddr2", resultPAY0031DInfo.get("taxInvcAddr2"));
      pay27d_insert.put("noteAddr3", resultPAY0031DInfo.get("taxInvcAddr3"));
      pay27d_insert.put("noteAddr4", resultPAY0031DInfo.get("taxInvcAddr4"));
      pay27d_insert.put("notePostCode", resultPAY0031DInfo.get("taxInvcPostCode"));
      pay27d_insert.put("noteAreaName", "");
      pay27d_insert.put("noteStateName", resultPAY0031DInfo.get("taxInvcStateName"));
      pay27d_insert.put("noteCntyName", resultPAY0031DInfo.get("taxInvcCnty"));
      pay27d_insert.put("noteTxs", resultPAY0031DInfo.get("taxInvcTxs"));
      pay27d_insert.put("noteChrg", resultPAY0031DInfo.get("taxInvcChrg"));
      pay27d_insert.put("noteAmtDue", resultPAY0031DInfo.get("taxInvcAmtDue"));
      pay27d_insert.put("noteRem", "AS RESULT REVERSAL - " + resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay27d_insert.put("noteStusId", "4");
      pay27d_insert.put("noteCrtDt", new Date());
      pay27d_insert.put("noteCrtUserId", svc0004dmap.get("updator"));
      ASManagementListMapper.reverse_PAY0027D(pay27d_insert);
      ////////////////// pay27d end ////////////////////

      if (reverse_PAY0012D_cnt > 0) {
        svc0004dmap.put("NOTE_ID", PAY0027DSEQ);
        int reverse_PAY0028D_cnt = ASManagementListMapper.reverse_PAY0028D(svc0004dmap);
      }

      ////////////////// pay17d pay18d ////////////////////
      EgovMap PAY0017DSEQMap = ASManagementListMapper.getPAY0017DSEQ(params);
      String PAY0017DSEQ = String.valueOf(PAY0017DSEQMap.get("seq"));
      svc0004dmap.put("ACC_INV_VOID_ID", PAY0017DSEQ);
      svc0004dmap.put("accInvVoidSubCrditNoteId", PAY0016DSEQ);
      svc0004dmap.put("accInvVoidSubCrditNote", CNNO);
      setPay17dData(svc0004dmap);
      setPay18dData(svc0004dmap);
      ////////////////// pay17d pay18d end////////////////////

      ////////////////// pay06d ////////////////////
      EgovMap pay06d_insert = new EgovMap();
      pay06d_insert.put("asId", AS_ID);
      pay06d_insert.put("asDocNo", CNNO);
      pay06d_insert.put("asLgDocTypeId", "155");
      pay06d_insert.put("asLgDt", new Date());
      pay06d_insert.put("asLgAmt", (((BigDecimal) resultPAY0031DInfo.get("taxInvcAmtDue")).negate()));
      pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
      pay06d_insert.put("asLgUpdDt", new Date());
      pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
      pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
      pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
      pay06d_insert.put("asAdvPay", "0");
      pay06d_insert.put("r01", "");

      int reverse_PAY0006D_cnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
      ////////////////// pay06d end////////////////////
    }
//
//    ////////////////// pay06d ////////////////////
//    /// Restore Advanced AS Payment Use In Current Result
//    List<EgovMap> p6dList = ASManagementListMapper.getResult_PAY0006D(svc0004dmap);
//    if (null != p6dList && p6dList.size() > 0) {
//      for (int i = 0; i < p6dList.size(); i++) {
//        EgovMap pay06d_insert = p6dList.get(i);
//
//        ////////////////// pay06d 1set ////////////////////
//        double p16d_asTotAmt = pay06d_insert.get("asLgAmt") == null ? 0
//            : Double.parseDouble((String) pay06d_insert.get("asLgAmt"));
//
//        pay06d_insert.put("asId", AS_ID);
//        pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
//        pay06d_insert.put("asLgDocTypeId", "163");
//        pay06d_insert.put("asLgDt", new Date());
//        pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
//        pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//        pay06d_insert.put("asLgUpdDt", new Date());
//        pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
//        pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
//        pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
//        pay06d_insert.put("asAdvPay", "1");
//        pay06d_insert.put("r01", "");
//
//        int reverse_PAY0006D_1setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
//        ////////////////// pay06d 1set end////////////////
//
//        ////////////////// pay06d 2set ////////////////////
//        pay06d_insert.put("asId", AS_ID);
//        pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
//        pay06d_insert.put("asLgDocTypeId", "401");
//        pay06d_insert.put("asLgDt", new Date());
//        pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
//        pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//        pay06d_insert.put("asLgUpdDt", new Date());
//        pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
//        pay06d_insert.put("asResultNo", "");
//        pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
//        pay06d_insert.put("asAdvPay", "1");
//        pay06d_insert.put("r01", "");
//
//        int reverse_PAY0006D_2setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
//        ////////////////// pay06d 2set end////////////////
//      }
//    }
//    ////////////////// pay06d end ////////////////////
//
//    // Reverse All AS Payment Transaction Including Reverse Payment,because
//    // reverse payment can be partial amount
//    List<EgovMap> p7dList = ASManagementListMapper.getResult_PAY0007D(svc0004dmap);
//    if (null != p7dList && p7dList.size() > 0) {
//
//      ////////////////// pay07d update ////////////////
//      int reverse_StateUpPAY0007D_cnt = ASManagementListMapper.reverse_StateUpPAY0007D(svc0004dmap);
//      ////////////////// pay07d update ////////////////
//
//      ////////////////// PAY0064D SELECT ////////////////
//
//      svc0004dmap.put("BILL_ID", String.valueOf((p7dList.get(0)).get("billId")));
//      List<EgovMap> p64dList = ASManagementListMapper.getResult_PAY0064D(svc0004dmap);
//      ////////////////// PAY0064D ////////////////
//      if (null != p64dList && p64dList.size() > 0) {
//        for (int i = 0; i < p64dList.size(); i++) {
//
//          EgovMap p64dList_Map = p64dList.get(i);
//          double trxTotAmt = p64dList_Map.get("totAmt") == null ? 0
//              : Double.parseDouble((String) p64dList_Map.get("totAmt"));
//
//          Map PAY_DocNoMap = null;
//          String PAYNO_REV = null;
//
//          params.put("DOCNO", "82");
//          PAY_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
//          PAYNO_REV = String.valueOf(PAY_DocNoMap.get("asno"));
//
//          EgovMap PAY0069DSEQMap = ASManagementListMapper.getPAY0069DSEQ(params);
//          String PAY0069DSEQ = String.valueOf(PAY0069DSEQMap.get("seq"));
//
//          ////////////////// PAY0069D insert ////////////////
//          EgovMap pay069d_insert = new EgovMap();
//          pay069d_insert.put("trxId", PAY0069DSEQ);
//          pay069d_insert.put("trxDt", new Date());
//          pay069d_insert.put("trxType", "101");
//          pay069d_insert.put("trxAmt", (-1 * trxTotAmt));
//          pay069d_insert.put("trxMtchNo", "");
//
//          int insert_PAY0069D_cnt = ASManagementListMapper.insert_PAY0069D(pay069d_insert);
//          ////////////////// PAY0069D out ////////////////
//
//          ////////////////// PAY0064D insert ////////////////
//          EgovMap PAY0064DSEQMap = ASManagementListMapper.getPAY0064DSEQ(params);
//          String PAY0064DSEQ = String.valueOf(PAY0064DSEQMap.get("seq"));
//
//          EgovMap pay064d_insert = new EgovMap();
//          pay064d_insert.put("payId", PAY0064DSEQ);
//          pay064d_insert.put("orNo", PAYNO_REV);
//          pay064d_insert.put("salesOrdId", p64dList_Map.get("saleOrdId"));
//          pay064d_insert.put("billId", p64dList_Map.get("billId"));
//          pay064d_insert.put("trNo", p64dList_Map.get("trNo"));
//          pay064d_insert.put("typeId", "101");
//          pay064d_insert.put("payData", new Date());
//          pay064d_insert.put("bankChgAmt", p64dList_Map.get("bankChgAmt"));
//          pay064d_insert.put("bankChgAccId", p64dList_Map.get("bankChgAccId"));
//          pay064d_insert.put("collMemId", p64dList_Map.get("collMemId"));
//          pay064d_insert.put("brnchId", params.get("brnchId"));
//          pay064d_insert.put("bankAccId", p64dList_Map.get("bankAccId"));
//          pay064d_insert.put("allowComm", p64dList_Map.get("allowComm"));
//          pay064d_insert.put("stusCodeId", "1");
//          pay064d_insert.put("updUserId", svc0004dmap.get("updator"));
//          pay064d_insert.put("updDt", new Date());
//          pay064d_insert.put("syncHeck", "0");
//          pay064d_insert.put("custId3party", p64dList_Map.get("custId3party"));
//          double p46TotAmt = p64dList_Map.get("totAmt") == null ? 0
//              : Double.parseDouble((String) p64dList_Map.get("totAmt"));
//          pay064d_insert.put("totAmt", (-1 * p46TotAmt));
//          pay064d_insert.put("mtchId", p64dList_Map.get("payId"));
//          pay064d_insert.put("crtUserId", svc0004dmap.get("updator"));
//          pay064d_insert.put("crtDt", new Date());
//          pay064d_insert.put("isAllowRevMulti", "0");
//          pay064d_insert.put("isGlPostClm", "0");
//          pay064d_insert.put("glPostClmDt", "01/01/1900");
//          pay064d_insert.put("trxId", PAY0069DSEQ);
//          pay064d_insert.put("advMonth", "0");
//          pay064d_insert.put("accBillId", "0");
//          pay064d_insert.put("trIssuDt", "");
//          pay064d_insert.put("taxInvcIsGen", "0");
//          pay064d_insert.put("taxInvcRefNo", "");
//          pay064d_insert.put("taxInvcRefDt", "");
//          pay064d_insert.put("svcCntrctId", "0");
//          pay064d_insert.put("batchPayId", "0");
//          int insert_PAY0064D_cnt = ASManagementListMapper.insert_PAY0064D(pay069d_insert);
//          ////////////////// PAY0064D out ////////////////
//
//          ////////////////// PAY0065D insert ////////////////
//          svc0004dmap.put("PAY_ID", PAY0064DSEQ);
//          List<EgovMap> p65dList = ASManagementListMapper.getResult_PAY0065D(svc0004dmap);
//          EgovMap PAY0065DSEQMap = ASManagementListMapper.getPAY0065DSEQ(params);
//          String PAY0065DSEQ = String.valueOf(PAY0065DSEQMap.get("seq"));
//
//          if (null != p65dList && p65dList.size() > 0) {
//            for (int a = 0; a < p65dList.size(); a++) {
//
//              ////////////////// PAY0065D insert ////////////////
//              EgovMap p65dList_Map = p65dList.get(i);
//              double payTotAmt = p65dList_Map.get("payItmAmt") == null ? 0
//                  : Double.parseDouble(((String) p65dList_Map.get("payItmAmt")));
//
//              EgovMap pay065d_insert = new EgovMap();
//              pay065d_insert.put("payItmId", PAY0065DSEQ);
//              pay065d_insert.put("payId", PAY0064DSEQ);
//              pay065d_insert.put("payItmModeId", p65dList_Map.get("payItmModeId"));
//              pay065d_insert.put("payItmRefNo", p65dList_Map.get("payItmRefNo"));
//              pay065d_insert.put("payItmCcNo", p65dList_Map.get("payItmCcNo"));
//              pay065d_insert.put("payItmOriCcNo", p65dList_Map.get("payItmOriCcNo"));
//              pay065d_insert.put("payItmEncryptCcNo", p65dList_Map.get("payItmEncryptCcNo"));
//              pay065d_insert.put("payItmCcTypeId", p65dList_Map.get("payItmCcTypeId"));
//              pay065d_insert.put("payItmChqNo", p65dList_Map.get("payItmChqNo"));
//              pay065d_insert.put("payItmIssuBankId", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmAmt", (-1 * payTotAmt));
//              pay065d_insert.put("payItmIsOnline", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmBankAccId", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmRefDt", "01/01/1900");
//              pay065d_insert.put("payItmAppvNo", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmRem", "AS RESULT EDIT (REVERSE PAYMENT)");
//              pay065d_insert.put("payItmStusId", "1");
//              pay065d_insert.put("payItmIsLok", "0");
//              pay065d_insert.put("payItmCcHolderName", p65dList_Map.get("payItmCcHolderName"));
//              pay065d_insert.put("payItmCcExprDt", p65dList_Map.get("payItmCcExprDt"));
//              pay065d_insert.put("payItmBankChrgAmt", p65dList_Map.get("payItmBankChrgAmt"));
//              pay065d_insert.put("payItmIsThrdParty", p65dList_Map.get("payItmIsThrdParty"));
//              pay065d_insert.put("payItmThrdPartyIc", p65dList_Map.get("payItmThrdPartyIc"));
//              pay065d_insert.put("payItmRefItmId", p65dList_Map.get("payItmId"));
//              pay065d_insert.put("skipRecon", "0");
//
//              pay065d_insert.put("payItmBankBrnchId", "0");
//              pay065d_insert.put("payItmBankInSlipNo", "0");
//              pay065d_insert.put("payItmEftNo", "0");
//              pay065d_insert.put("payItmChqDepReciptNo", "0");
//              pay065d_insert.put("etc1", "0");
//              pay065d_insert.put("etc2", "0");
//              pay065d_insert.put("etc3", "0");
//              pay065d_insert.put("payItmGrpId", "0");
//              pay065d_insert.put("payItmBankChrgAccId", "0");
//              pay065d_insert.put("updUserId", "0");
//              pay065d_insert.put("updDt", "");
//              pay065d_insert.put("isFundTrnsfr", "0");
//              pay065d_insert.put("payItmCardTypeId", "0");
//              pay065d_insert.put("payItmCardModeId", "0");
//              pay065d_insert.put("payItmRunngNo", "");
//              pay065d_insert.put("payItmMid", "");
//
//              int insert_PAY0065D_cnt = ASManagementListMapper.insert_PAY0065D(pay065d_insert);
//              ////////////////// PAY0065D insert ////////////////
//
//              ////////////////// PAY0009D insert ////////////////
//              EgovMap pay09d_insert = new EgovMap();
//              pay09d_insert.put("glPostngDt", new Date());
//              pay09d_insert.put("glFiscalDt", "01/01/1900");
//              pay09d_insert.put("glBatchNo", PAY0064DSEQ);
//              pay09d_insert.put("glBatchTypeDesc", "");
//              pay09d_insert.put("glBatchTot", (-1 * payTotAmt));
//              pay09d_insert.put("glReciptNo", PAYNO_REV);
//              pay09d_insert.put("glReciptTypeId", "101");
//              pay09d_insert.put("glReciptBrnchId", svc0004dmap.get("brnchId"));
//
//              if ("107".equals(p65dList_Map.get("payItmModeId"))) { // ConvertTempAccountToSettlementAccount
//                int t_payItmIssuBankId = p65dList_Map.get("payItmIssuBankId") == null ? 0
//                    : Integer.parseInt((String) p65dList_Map.get("payItmIssuBankId"));
//                pay09d_insert.put("glReciptSetlAccId", this.convertTempAccountToSettlementAccount(t_payItmIssuBankId));
//                pay09d_insert.put("glReciptAccId", p65dList_Map.get("payItmIssuBankId"));
//
//              } else {
//                int t_payItmModeId = p65dList_Map.get("payItmModeId") == null ? 0
//                    : Integer.parseInt((String) p65dList_Map.get("payItmModeId"));
//                pay09d_insert.put("glReciptAccId", this.convertAccountToTempBasedOnPayMode(t_payItmModeId)); // ConvertAccountToTempBasedOnPayMode
//                pay09d_insert.put("glReciptSetlAccId", "0");
//              }
//
//              pay09d_insert.put("glReciptItmId", PAY0065DSEQ);
//              pay09d_insert.put("glReciptItmModeId", p65dList_Map.get("payItmModeId"));
//              pay09d_insert.put("glRevrsReciptItmId", p65dList_Map.get("payItmId"));
//              pay09d_insert.put("glReciptItmAmt", (-1 * payTotAmt));
//
//              double t_payItemBankChargeAmt = p65dList_Map.get("payItmBankChrgAmt") == null ? 0
//                  : Double.parseDouble(((String) p65dList_Map.get("payItmBankChrgAmt")));
//              pay09d_insert.put("glReciptItmChrg", t_payItemBankChargeAmt);
//              pay09d_insert.put("glReciptItmRclStus", "N");
//              pay09d_insert.put("glJrnlNo", "");
//              pay09d_insert.put("glAuditRef", "");
//              pay09d_insert.put("glCnvrStus", "Y");
//              pay09d_insert.put("glCnvrDt", "");
//              int insert_PAY0009D_cnt = ASManagementListMapper.insert_PAY0009D(pay09d_insert);
//              ////////////////// PAY0009D insert ////////////////
//
//            } // p65dList for eof
//          } // p65dList eof
//
//          ////////////////// PAY0006D inert ////////////////
//          svc0004dmap.put("AS_DOC_NO", String.valueOf(p64dList_Map.get("orNo")));
//          List<EgovMap> p06dList = ASManagementListMapper.getResult_DocNo_PAY0006D(svc0004dmap);
//
//          if (null != p06dList && p06dList.size() > 0) {
//            for (int a = 0; a < p06dList.size(); a++) {
//
//              EgovMap p06dList_Map = p06dList.get(i);
//              double asLgAmt = p06dList_Map.get("asLgAmt") == null ? 0
//                  : Double.parseDouble(((String) p06dList_Map.get("asLgAmt")));
//
//              ////////////////// pay06d ////////////////////
//              EgovMap pay06d_insert = new EgovMap();
//
//              pay06d_insert.put("asId", AS_ID);
//              pay06d_insert.put("asDocNo", PAYNO_REV);
//              pay06d_insert.put("asLgDocTypeId", "160");
//              pay06d_insert.put("asLgDt", new Date());
//              pay06d_insert.put("asLgAmt", (asLgAmt * -1));
//              pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//              pay06d_insert.put("asLgUpdDt", new Date());
//              pay06d_insert.put("asSoNo", p06dList_Map.get("asSoNo"));
//              pay06d_insert.put("asResultNo", p06dList_Map.get("asSoNo"));
//              pay06d_insert.put("asSoId", p06dList_Map.get("asSoId"));
//              pay06d_insert.put("asAdvPay", p06dList_Map.get("asAdvPay"));
//              pay06d_insert.put("r01", "");
//
//              int reverse_PAY0006D_cnt = ASManagementListMapper.reverse_DocNo_PAY0006D(pay06d_insert);
//
//            }
//          }
//          ////////////////// PAY0006D out////////////////
//        }
//      }
//
//    } // p7dList eof

    ////////////////// CCR0001D insert ////////////////
    svc0004dmap.put("HC_TYPE_NO", svc0004dmap.get("AS_NO"));
    int reverse_State_CCR0001D_cnt = ASManagementListMapper.reverse_State_CCR0001D(svc0004dmap);
    ////////////////// CCR0001D insert ////////////////
    LOGGER.debug("==========asResult_update  Log  in================");

    ////////////////// ADD NEW AS RESULT ////////////////
    ((Map) params.get("asResultM")).put("AUTOINSERT", "TRUE");// hash
    EgovMap returnemp = this.asResult_insert(params);
    returnemp.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);

    return returnemp;

  }

  @Override
  public int setPay17dData(Map<String, Object> params) {

    LOGGER.debug("                                  ===> setPay17dData   out");
    Map<String, Object> pay17dMap = new HashMap();

    EgovMap pay27d_insert = new EgovMap();

    params.put("DOCNO", "112");
    Map DocNoMap = ASManagementListMapper.getASEntryDocNo(params);

    pay17dMap.put("accInvVoidId", params.get("ACC_INV_VOID_ID"));
    pay17dMap.put("accInvVoidRefNo", String.valueOf(DocNoMap.get("asno")));
    pay17dMap.put("accInvVoidInvcNo", params.get("ACC_INVOICE_NO"));
    pay17dMap.put("accInvVoidInvcAmt", params.get("AS_TOT_AMT"));
    pay17dMap.put("accInvVoidRem", "AS Result Reversal.");
    pay17dMap.put("accInvVoidStusId", "1");
    pay17dMap.put("accInvVoidCrtUserId", params.get("updator"));
    pay17dMap.put("accInvVoidCrtDt", new Date());

    int a = ASManagementListMapper.insert_Pay0017d(pay17dMap);

    return a;
  }

  @Override
  public int setPay18dData(Map<String, Object> params) {

    LOGGER.debug("                                  ===> pay18dMap   out");
    Map<String, Object> pay18dMap = new HashMap();

    pay18dMap.put("accInvVoidId", params.get("ACC_INV_VOID_ID"));
    pay18dMap.put("accInvVoidSubOrdId", params.get("AS_SO_ID"));
    pay18dMap.put("accInvVoidSubBillId", params.get("ACC_BILL_ID"));
    pay18dMap.put("accInvVoidSubBillAmt", params.get("AS_TOT_AMT"));
    pay18dMap.put("accInvVoidSubCrditNote", params.get("accInvVoidSubCrditNote"));
    pay18dMap.put("accInvVoidSubCrditNoteId", params.get("accInvVoidSubCrditNoteId"));
    pay18dMap.put("accInvVoidSubRem", "Result Reversal.");

    int a = ASManagementListMapper.insert_Pay0018d(pay18dMap);

    return a;
  }

  @Override
  public int asResultBasic_update(Map<String, Object> params) {

    LinkedHashMap svc0004dmap = (LinkedHashMap) params.get("asResultM");
    int c = -1;
    List<EgovMap> DefectTypSCList = ASManagementListMapper
        .getDefectTypSCList(svc0004dmap.get("AS_SLUTN_RESN_ID").toString());

    if (svc0004dmap.get("AS_RESULT_STUS_ID").equals("1")) { // IN HOUSE REPAIR
      c = ASManagementListMapper.updateBasicInhouseSVC0004D(svc0004dmap);
      ASManagementListMapper.updateBasicInhouseSVC0001D(svc0004dmap);
    } else { // OTHER STATUS
      c = ASManagementListMapper.updateBasicSVC0004D(svc0004dmap);
      if (svc0004dmap.get("AS_RESULT_STUS_ID").equals("4")) {
        // if (String.valueOf(svc0004dmap.get("AS_SLUTN_RESN_ID")).equals("454") || String.valueOf(svc0004dmap.get("AS_SLUTN_RESN_ID")).equals("7018") ) {
        LOGGER.debug("================   DefectTypSCList : " + DefectTypSCList + "   svc0004dmap : " + svc0004dmap);
        boolean DefectList = DefectTypSCList.isEmpty();
        if (DefectList != true) {
          params.put("AS_SO_ID", svc0004dmap.get("AS_SO_ID"));
          this.saveASEntryInHouse(params);
        }
      }

      if (CommonUtils.nvl(svc0004dmap.get("AS_REPLACEMENT")).equals("0")) { // REPLACE A NEW UNIT?
        ASManagementListMapper.updateInHouseNOReplaceMentSVC0004D(svc0004dmap);
        ASManagementListMapper.updateBasicInhouseSVC0001D(svc0004dmap);
      }
    }
    return c;
  }

  @Override
  public int convertAccountToTempBasedOnPayMode(int pMode) {
    int rc = 0;
    switch (pMode) {
      case 105:// cash
        rc = 531;
        break;
      case 106:// cheque
        rc = 532;
        break;
      case 108:// online
        rc = 533;
        break;
      default:
        break;
    }
    return rc;
  }

  @Override
  public int convertTempAccountToSettlementAccount(int p) {

    int rc = 0;
    switch (p) {
      case 99:
        rc = 83;
        break;
      case 100:
        rc = 90;
        break;
      case 101:
        rc = 84;
        break;
      case 102:
        rc = 92;
        break;
      case 103:
        rc = 83;
        break;
      case 104:
        rc = 86;
        break;
      case 105:
        rc = 85;
        break;
      case 106:
        rc = 84;
        break;
      case 107:
        rc = 88;
        break;
      case 110:
        rc = 89;
        break;
      case 497:
        rc = 497;
        break;
      case 545:
        rc = 546;
        break;
      case 553:
        rc = 551;
        break;
      default:
        break;
    }
    return rc;
  }

  private Map<String, Object> getSaveASEntry(Map<String, Object> params, SessionVO sessionVO) {
    Map<String, Object> asEntry = new HashMap<String, Object>();
    asEntry.put("ASID", 0);
    asEntry.put("ASNo", "");
    asEntry.put("ASSOID", Integer.parseInt(params.get("hiddenOrderID").toString()));
    asEntry.put("ASMemID", Integer.parseInt(params.get("assignCT").toString()));
    asEntry.put("ASMemGroup", Integer.parseInt(params.get("CTGroup").toString()));
    asEntry.put("ASMemGroup", Integer.parseInt(params.get("CTGroup").toString()));

    if (CommonUtils.isNotEmpty(params.get("requestDate").toString())) {
      asEntry.put("ASRequestDate", params.get("requestDate"));
    } else {
      asEntry.put("ASRequestDate", "01/01/1900");
    }

    if (CommonUtils.isNotEmpty(params.get("appDate").toString())) {
      asEntry.put("ASAppoinmentDate", params.get("appDate"));
    } else {
      asEntry.put("ASAppoinmentDate", "01/01/1900");
    }
    asEntry.put("ASBranchID", Integer.parseInt(params.get("branchDSC").toString()));
    asEntry.put("ASMalfunctionID", Integer.parseInt(params.get("errorCode").toString()));
    asEntry.put("ASMalfunctionReasonID", Integer.parseInt(params.get("errorDesc").toString()));
    asEntry.put("ASRemarkRequestor", params.get("requestor").toString().trim());
    asEntry.put("ASRemarkRequestorContact", params.get("requestorCont").toString().trim());
    asEntry.put("ASCalllogID", 0);
    asEntry.put("ASStatusID", 1);
    asEntry.put("ASSMS", false);
    asEntry.put("ASCreateBy", sessionVO.getUserId());
    asEntry.put("ASCreateAt", new DATE());
    asEntry.put("ASUpdateBy", sessionVO.getUserId());
    asEntry.put("ASUpdateAt", new DATE());
    asEntry.put("ASEntryIsSynch", false);
    asEntry.put("ASEntryIsEdit", false);
    asEntry.put("ASTypeID", 674);
    asEntry.put("ASRequestorTypeID", Integer.parseInt(params.get("requestor").toString()));
    asEntry.put("ASIsBSWithin30Days", params.get("checkBS") != null ? true : false);
    asEntry.put("ASAllowComm", params.get("checkComm") != null ? true : false);
    asEntry.put("ASRemarkAdditionalContact", params.get("additionalCont").toString().trim());
    asEntry.put("ASRemarkRequestorContactSMS", params.get("checkSms1") != null ? true : false);
    asEntry.put("ASRemarkAdditionalContactSMS", params.get("checkSms2") != null ? true : false);

    return asEntry;
  }

  @Override
  public List<EgovMap> selectCTByDSC(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.selectCTByDSC(params);
  }

  @Override
  public EgovMap getAsEventInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.getAsEventInfo(params);
  }

  @Override
  public List<EgovMap> selectSVC0023T(Map<String, Object> params) {
    return ASManagementListMapper.selectSVC0023T(params);
  }

  @Override
  public List<EgovMap> selectSVC0024T(Map<String, Object> params) {
    return ASManagementListMapper.selectSVC0024T(params);
  }

  @Override
  public List<EgovMap> selectSVC0025T(Map<String, Object> params) {
    return ASManagementListMapper.selectSVC0025T(params);
  }

  @Override
  public List<EgovMap> selectSVC0026T(Map<String, Object> params) {
    return ASManagementListMapper.selectSVC0026T(params);
  }

  // AS RECEIVED ENTRY POP UP NOTIFICATION -- TPY
  @Override
  public EgovMap checkASReceiveEntry(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.checkASReceiveEntry(params);
  }

  public EgovMap checkASCom(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.checkASCom(params);
  }

  public EgovMap checkHSStatus(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.checkHSStatus(params);
  }

  public EgovMap checkWarrentyStatus(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.checkWarrentyStatus(params);
  }

  @Override
  public EgovMap checkSpecialAgreement(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return ASManagementListMapper.checkSpecialAgreement(params);
  }

  @Override
  public List<EgovMap> checkAOASRcdStat(Map<String, Object> params) {
    return ASManagementListMapper.checkAOASRcdStat(params);
  }

  @Override
  public String getInHseLmtDy() {
    return ASManagementListMapper.getInHseLmtDy();
  }

  @Override
  public int selRcdTms(Map<String, Object> params) {
    return ASManagementListMapper.selRcdTms(params);
  }

  @Override
  public int chkPmtMap(Map<String, Object> params) {
    return ASManagementListMapper.chkPmtMap(params);
  }

  @Override
  public int chkRcdTms(Map<String, Object> params) {
    return ASManagementListMapper.chkRcdTms(params);
  }

  @Override
  public String getSearchDtRange() {
    return ASManagementListMapper.getSearchDtRange();
  }

  @Override
  public List<EgovMap> selectAsTyp() {
    return ASManagementListMapper.selectAsTyp();
  }

  @Override
  public List<EgovMap> selectAsStat() {
    return ASManagementListMapper.selectAsStat();
  }

  @Override
  public List<EgovMap> asProd() {
    return ASManagementListMapper.asProd();
  }

  @Override
  public List<EgovMap> selectAsCrtStat() {
    return ASManagementListMapper.selectAsCrtStat();
  }

  @Override
  public List<EgovMap> selectTimePick() {
    return ASManagementListMapper.selectTimePick();
  }

  @Override
  public List<EgovMap> selectLbrFeeChr(Map<String, Object> params) {
    return ASManagementListMapper.selectLbrFeeChr(params);
  }

  @Override
  public List<EgovMap> selectFltQty() {
    return ASManagementListMapper.selectFltQty();
  }

  @Override
  public List<EgovMap> selectFltPmtTyp() {
    return ASManagementListMapper.selectFltPmtTyp();
  }

  @Override
  public List<EgovMap> getASEntryCommission(Map<String, Object> params) {
    return ASManagementListMapper.getASEntryCommission(params);
  }

  @Override
  public List<EgovMap> getDftTyp(Map<String, Object> params) {
    return ASManagementListMapper.getDftTyp(params);
  }

  @Override
  public ReturnMessage newASInHouseAddSerial(Map<String, Object> params) {

    ReturnMessage message = new ReturnMessage();

    HashMap<String, Object> mp = new HashMap<String, Object>();
    Map<?, ?> svc0004dmap = (Map<?, ?>) params.get("asResultM");
    mp.put("serviceNo", svc0004dmap.get("AS_NO"));

    params.put("asNo", svc0004dmap.get("AS_NO"));
    params.put("asEntryId", svc0004dmap.get("AS_ENTRY_ID"));
    params.put("asSoId", svc0004dmap.get("AS_SO_ID"));
    params.put("rcdTms", svc0004dmap.get("RCD_TMS"));
    params.put("chkInstallAcc", svc0004dmap.get("INS_ACC_CHK"));

    int noRcd = this.chkRcdTms(params);

    if (noRcd == 1) { // RECORD ABLE TO UPDATE
      int isAsCnt = this.isAsAlreadyResult(mp);
      LOGGER.debug("== isAsCnt " + isAsCnt);

      if (isAsCnt == 0) {
        EgovMap rtnValue = this.asResult_insert(params);
        if (null != rtnValue) {
          HashMap spMap = (HashMap) rtnValue.get("spMap");
          LOGGER.debug("spMap :" + spMap.toString());

          if (!spMap.isEmpty()) {
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }

            servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

            LOGGER.debug("SP_SVC_LOGISTIC_REQUEST_SERIAL===> " + spMap.toString());

            String errCode = (String) spMap.get("pErrcode");
            String errMsg = (String) spMap.get("pErrmsg");

            LOGGER.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
            LOGGER.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

            // pErrcode : 000 = Success, others = Fail
            if (!"000".equals(errCode)) {
              throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
            }
          }

          // ONGHC ADD FOR OPTIONAL FILTER
          boolean rst = this.insertOptFlt(params);

          // KR-OHK Barcode Save Start
          Map<String, Object> setmap = new HashMap();
          setmap.put("serialNo", svc0004dmap.get("SERIAL_NO"));
          setmap.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
          setmap.put("reqstNo", rtnValue.get("asNo"));
          setmap.put("callGbn", "AS");
          setmap.put("mobileYn", "N");
          setmap.put("userId", params.get("updator"));

          servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

          String errCode = (String) setmap.get("pErrcode");
          String errMsg = (String) setmap.get("pErrmsg");

          LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS ERROR CODE : " + errCode);
          LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS ERROR MSG: " + errMsg);

          // pErrcode : 000 = Success, others = Fail
          if (!"000".equals(errCode)) {
            throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
          }
          // KR-OHK Barcode Save Start
        }

        message.setCode(AppConstants.SUCCESS);
        message.setData(rtnValue.get("asNo"));
        message.setMessage("");

      } else {
        message.setCode("98");
        message.setData(svc0004dmap.get("AS_NO"));
        message.setMessage("Result already exist with Complete Status.");
      }
    } else {
      message.setMessage(
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }

    return message;
  }

  @Override
  public String getSerialChk(Map<String, Object> params) {
    return ASManagementListMapper.getSerialChk(params);
  }

  @Override
  public int asResultBasic_updateSerial(Map<String, Object> params) {

    LinkedHashMap svc0004dmap = (LinkedHashMap) params.get("asResultM");
    int c = -1;
    List<EgovMap> DefectTypSCList = ASManagementListMapper
        .getDefectTypSCList(svc0004dmap.get("AS_SLUTN_RESN_ID").toString());

    if (svc0004dmap.get("AS_RESULT_STUS_ID").equals("1")) { // IN HOUSE REPAIR
      c = ASManagementListMapper.updateBasicInhouseSVC0004D(svc0004dmap);
      ASManagementListMapper.updateBasicInhouseSVC0001D(svc0004dmap);
    } else { // OTHER STATUS
      c = ASManagementListMapper.updateBasicSVC0004D(svc0004dmap);
      if (svc0004dmap.get("AS_RESULT_STUS_ID").equals("4")) {
        // if (String.valueOf(svc0004dmap.get("AS_SLUTN_RESN_ID")).equals("454") || String.valueOf(svc0004dmap.get("AS_SLUTN_RESN_ID")).equals("7018") ) {
        LOGGER.debug("================   DefectTypSCList : " + DefectTypSCList + "   svc0004dmap : " + svc0004dmap);
        boolean DefectList = DefectTypSCList.isEmpty();
        if (DefectList != true) {
          params.put("AS_SO_ID", svc0004dmap.get("AS_SO_ID"));
          this.saveASEntryInHouse(params);
        }
      }

      if (CommonUtils.nvl(svc0004dmap.get("AS_REPLACEMENT")).equals("0")) { // REPLACE A NEW UNIT?
        ASManagementListMapper.updateInHouseNOReplaceMentSVC0004D(svc0004dmap);
        ASManagementListMapper.updateBasicInhouseSVC0001D(svc0004dmap);
      }
    }

    // KR-OHK Barcode Save Start
    Map<String, Object> setmap = new HashMap();
    setmap.put("serialNo", svc0004dmap.get("SERIAL_NO"));
    setmap.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
    setmap.put("reqstNo", svc0004dmap.get("AS_RESULT_NO"));
    setmap.put("callGbn", "AS_EDIT");
    setmap.put("mobileYn", "N");
    setmap.put("userId", params.get("updator"));

    servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

    String errCode = (String) setmap.get("pErrcode");
    String errMsg = (String) setmap.get("pErrmsg");

    LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_EDIT ERROR CODE : " + errCode);
    LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_EDIT ERROR MSG: " + errMsg);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCode)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
    }
    // KR-OHK Barcode Save Start

    return c;
  }

  @Override
  public EgovMap selectCustomerInstallationAddress(Map<String, Object> params) throws Exception {

    return ASManagementListMapper.selectCustomerInstallationAddress(params);
  }

  @Override
public List<EgovMap> selectDefectEntry(Map<String, Object> params) {
  return ASManagementListMapper.selectDefectEntry(params);
}

  @Override
  public EgovMap asResult_updateSerial(Map<String, Object> params) {
    // AS'S EDIT RESULT
    ArrayList<AsResultChargesViewVO> vewList = null;
    List<EgovMap> addItemList = null;
    List<EgovMap> resultMList = null;

    LinkedHashMap svc0004dmap = null;
    EgovMap seqpay17Map = null;
    EgovMap eASEntryDocNo = null;
    EgovMap asResultASEntryId = null;
    EgovMap invoiceDocNo = null;

    String ACC_INV_VOID_ID = null;
    String NEW_AS_RESULT_ID = null;
    String NEW_AS_RESULT_NO = null;

    int asTotAmt = 0;

    svc0004dmap = (LinkedHashMap) params.get("asResultM");

    String AS_ID = String.valueOf(svc0004dmap.get("AS_ID"));
    String ACC_BILL_ID = String.valueOf(svc0004dmap.get("ACC_BILL_ID"));
    String ACC_INVOICE_NO = String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) != ""
        ? String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) : String.valueOf(svc0004dmap.get("AS_RESULT_NO"));
    params.put("ACC_BILL_ID", ACC_BILL_ID);
    params.put("ACC_INVOICE_NO", ACC_INVOICE_NO);

    seqpay17Map = ASManagementListMapper.getPAY0017SEQ(params);
    ACC_INV_VOID_ID = String.valueOf(seqpay17Map.get("seq"));
    params.put("ACC_INV_VOID_ID", ACC_INV_VOID_ID);

    params.put("DOCNO", "21");
    eASEntryDocNo = ASManagementListMapper.getASEntryDocNo(params);
    asResultASEntryId = ASManagementListMapper.getResultASEntryId(params);

    NEW_AS_RESULT_ID = String.valueOf(asResultASEntryId.get("seq"));
    NEW_AS_RESULT_NO = String.valueOf(eASEntryDocNo.get("asno"));

    svc0004dmap.put("NEW_AS_RESULT_ID", NEW_AS_RESULT_ID);
    svc0004dmap.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);
    svc0004dmap.put("updator", params.get("updator"));

    vewList = new ArrayList<AsResultChargesViewVO>();
    addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);

    // GET LATEST SVC0004D RECORD
    resultMList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

    EgovMap emp = (EgovMap) resultMList.get(0);
    svc0004dmap.put("AS_RESULT_ID", String.valueOf(emp.get("asResultId")));
    svc0004dmap.put("AS_RESULT_NO", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
    asTotAmt = Integer.parseInt(String.valueOf(((EgovMap) resultMList.get(0)).get("asTotAmt")));

    LOGGER.debug("== OLD SVC0004D'S RECORD : " + resultMList.toString());
    LOGGER.debug("== OLD TOTAL AMOUNT : " + asTotAmt);

    // KR-OHK Barcode Save Start
    Map<String, Object> setmapRev = new HashMap();
    setmapRev.put("serialNo", svc0004dmap.get("SERIAL_NO"));
    setmapRev.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
    setmapRev.put("reqstNo", svc0004dmap.get("AS_RESULT_NO"));
    setmapRev.put("callGbn", "AS_REVERSE");
    setmapRev.put("mobileYn", "N");
    setmapRev.put("userId", params.get("updator"));

    servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmapRev);

    String errCodeRev = (String) setmapRev.get("pErrcode");
    String errMsgRev = (String) setmapRev.get("pErrmsg");

    LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_REVERSE ERROR CODE : " + errCodeRev);
    LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_REVERSE ERROR MSG: " + errMsgRev);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCodeRev)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeRev + ":" + errMsgRev);
    }
    // KR-OHK Barcode Save Start

    // REVERSE SVC0004D
    svc0004dmap.put("OLD_AS_RESULT_ID", svc0004dmap.get("AS_RESULT_ID"));
    int reverse_SVC0004D_cnt = ASManagementListMapper.reverse_SVC0004D(svc0004dmap); // INSERT REVERSE SVC0004D
    int reverse_CURR_SVC0004D_cnt = ASManagementListMapper.reverse_CURR_SVC0004D(svc0004dmap); // UPDATE OLD ISCUR COLUMN TO 0 MAKE IT NOT THE LATEST RECORD
    int reverse_SVC0005D_cnt = ASManagementListMapper.reverse_CURR_SVC0005D(svc0004dmap); // INSERT REVERSE SVC0005D
    // INSERT REVERSE USED FILTER
    int reverse_LOG0103M_cnt = ASManagementListMapper.reverse_CURR_LOG0103M(svc0004dmap); // INSERT REVERSE SVC0005D

    // REVERSE LOGISTIC CALL
    Map<String, Object> logPram = null;
    logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", NEW_AS_RESULT_ID);
    logPram.put("RETYPE", "RETYPE");
    logPram.put("P_TYPE", "OD04");
    logPram.put("P_PRGNM", "ASCEN");
    logPram.put("USERID", String.valueOf(svc0004dmap.get("updator")));

    Map SRMap = new HashMap();
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE_SERIAL(logPram);
    LOGGER.debug("== RESULT CALL SP_LOGISTIC_REQUEST_REVERSE_SERIAL : " + logPram.toString());

    if (!"000".equals(logPram.get("p1"))) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1") + ":" + "AS EDIT Result Error");
    }

    // ADD NEW AS RESULT
    EgovMap cm = ASManagementListMapper.getLog0016DCount(svc0004dmap);
    int log0016dCnt = Integer.parseInt(String.valueOf(cm.get("cnt")));

    // AUTO REQUEST PDO (IF CURRENT RESULT HAS COMPLETE PDO CLAIM)
    if (log0016dCnt > 0) {
      LOGGER.debug("== START REQUEST PDO - START ==");
      EgovMap PDO_DocNoMap = null;
      EgovMap LOG_IDMap = null;
      String PDO_DocNo = null;
      String LOG16_ID = null;

      params.put("DOCNO", "26");
      PDO_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      PDO_DocNo = String.valueOf(PDO_DocNoMap.get("asno"));

      LOG_IDMap = ASManagementListMapper.getLOG0015DSEQ(params);
      LOG16_ID = String.valueOf(LOG_IDMap.get("seq"));

      svc0004dmap.put("STK_REQ_ID", LOG16_ID);
      svc0004dmap.put("STK_REQ_NO", PDO_DocNo);

      int a = ASManagementListMapper.insert_LOG0015D(svc0004dmap);
      if (a > 0) {
        int insert_LOG0016D_cnt = ASManagementListMapper.insert_LOG0016D(svc0004dmap);
      }
      LOGGER.debug("== START REQUEST PDO - END ==");
    }

    // Reverse InvStkRecordCard (Return Stock To Member's Hand) -- Prepare for
    // PDO return (ACF)
    // ~~~~~~~~~~~~~ 수정필요 SEELECT 후 INSERT 처리 하자. ......
    // ASManagementListMapper.insert_LOG0014D(svc0004dmap); 꼭 주석 ㅜ

    // CN Waive Billing (If Current Result has charge)
    if (asTotAmt > 0) {
      ASManagementListMapper.reverse_PAY0007D(svc0004dmap);

      svc0004dmap.put("ACC_BILL_ID", svc0004dmap.get("ACC_BILL_ID"));
      List<EgovMap> resultPAY0016DList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

      EgovMap pay0016dData = null;
      if (null != resultPAY0016DList) {
        int reverse_updatePAY0016D_cnt = ASManagementListMapper.reverse_updatePAY0016D(svc0004dmap);
      }

      pay0016dData = (EgovMap) ASManagementListMapper.getResult_PAY0016D(svc0004dmap);

      EgovMap CN_DocNoMap = null;
      String CNNO = null;

      EgovMap CNReportNo_DocNoMap = null;
      String CNReportNo = null;

      params.put("DOCNO", "134");
      CN_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      CNNO = String.valueOf(CN_DocNoMap.get("asno"));

      params.put("DOCNO", "18");
      CNReportNo_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
      CNReportNo = String.valueOf(CNReportNo_DocNoMap.get("asno"));

      List<EgovMap> resultPAY0031DList = null;
      svc0004dmap.put("accBillRem", pay0016dData.get("accBillRem"));
      resultPAY0031DList = ASManagementListMapper.getResult_PAY0031D(svc0004dmap);
      EgovMap resultPAY0031DInfo = resultPAY0031DList.get(0);

      ////////////////// pay16d AccOrderBill ////////////////////
      EgovMap PAY0016DSEQMap = ASManagementListMapper.getPAY0016DSEQ(params);
      String PAY0016DSEQ = String.valueOf(PAY0016DSEQMap.get("seq"));
      EgovMap pay16d_insert = new EgovMap();
      pay16d_insert.put("memoAdjId", PAY0016DSEQ);
      pay16d_insert.put("memoAdjRefNo", CNNO);
      pay16d_insert.put("memoAdjRptNo", CNReportNo);
      pay16d_insert.put("memoAdjTypeId", "1293");
      pay16d_insert.put("memoAdjInvcNo", pay0016dData.get("accBillRem"));
      pay16d_insert.put("memoAdjInvcTypeId", "128");
      pay16d_insert.put("memoAdjStusId", "4");
      pay16d_insert.put("memoAdjResnId", "2038");
      pay16d_insert.put("memoAdjRem", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay16d_insert.put("memoAdjTxsAmt", resultPAY0031DInfo.get("taxInvcTxs"));
      pay16d_insert.put("memoAdjTotAmt", resultPAY0031DInfo.get("taxInvcAmtDue"));
      pay16d_insert.put("memoAdjCrtDt", new Date());
      pay16d_insert.put("memoAdjCrtUserId", svc0004dmap.get("updator"));
      pay16d_insert.put("memoAdjUpdDt", new Date());
      pay16d_insert.put("memoAdjUpdUserId", svc0004dmap.get("updator"));
      pay16d_insert.put("batchId", "");
      ASManagementListMapper.reverse_PAY0016D(pay16d_insert);
      ////////////////// ////////////////////

      ////////////////// AccInvoiceAdjustment_Sub ////////////////////
      svc0004dmap.put("MEMO_ADJ_ID", PAY0016DSEQ);
      svc0004dmap.put("MEMO_ITM_TAX_CODE_ID", pay0016dData.get("accBillTaxCodeId"));
      svc0004dmap.put("MEMO_ITM_REM", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
      svc0004dmap.put("TAX_INVC_REF_NO", pay0016dData.get("accBillRem"));
      int reverse_PAY0012D_cnt = ASManagementListMapper.reverse_PAY0012D(svc0004dmap);
      ////////////////// pay12d ////////////////////

      ////////////////// pay27d AccTaxDebitCreditNote ////////////////////
      EgovMap PAY0027DSEQMap = ASManagementListMapper.getPAY0027DSEQ(params);
      String PAY0027DSEQ = String.valueOf(PAY0027DSEQMap.get("seq"));
      EgovMap pay27d_insert = new EgovMap();
      pay27d_insert.put("noteId", PAY0027DSEQ);
      pay27d_insert.put("noteEntryId", PAY0016DSEQ);
      pay27d_insert.put("noteTypeId", "1293");
      pay27d_insert.put("noteGrpNo", resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay27d_insert.put("noteRefNo", CNNO);
      pay27d_insert.put("noteRefDt", resultPAY0031DInfo.get("taxInvcRefDt"));
      pay27d_insert.put("noteInvcNo", pay0016dData.get("accBillRem"));
      pay27d_insert.put("noteInvcTypeId", "128");
      pay27d_insert.put("noteCustName", resultPAY0031DInfo.get("taxInvcCustName"));
      pay27d_insert.put("noteCntcPerson", resultPAY0031DInfo.get("taxInvcCntcPerson"));
      pay27d_insert.put("noteAddr1", resultPAY0031DInfo.get("taxInvcAddr1"));
      pay27d_insert.put("noteAddr2", resultPAY0031DInfo.get("taxInvcAddr2"));
      pay27d_insert.put("noteAddr3", resultPAY0031DInfo.get("taxInvcAddr3"));
      pay27d_insert.put("noteAddr4", resultPAY0031DInfo.get("taxInvcAddr4"));
      pay27d_insert.put("notePostCode", resultPAY0031DInfo.get("taxInvcPostCode"));
      pay27d_insert.put("noteAreaName", "");
      pay27d_insert.put("noteStateName", resultPAY0031DInfo.get("taxInvcStateName"));
      pay27d_insert.put("noteCntyName", resultPAY0031DInfo.get("taxInvcCnty"));
      pay27d_insert.put("noteTxs", resultPAY0031DInfo.get("taxInvcTxs"));
      pay27d_insert.put("noteChrg", resultPAY0031DInfo.get("taxInvcChrg"));
      pay27d_insert.put("noteAmtDue", resultPAY0031DInfo.get("taxInvcAmtDue"));
      pay27d_insert.put("noteRem", "AS RESULT REVERSAL - " + resultPAY0031DInfo.get("taxInvcSvcNo"));
      pay27d_insert.put("noteStusId", "4");
      pay27d_insert.put("noteCrtDt", new Date());
      pay27d_insert.put("noteCrtUserId", svc0004dmap.get("updator"));
      ASManagementListMapper.reverse_PAY0027D(pay27d_insert);
      ////////////////// pay27d end ////////////////////

      ////////// AccTaxDebitCreditNote_Sub ////////////
      if (reverse_PAY0012D_cnt > 0) {
        svc0004dmap.put("NOTE_ID", PAY0027DSEQ);
        int reverse_PAY0028D_cnt = ASManagementListMapper.reverse_PAY0028D(svc0004dmap);
      }

      ////////////////// pay17d pay18d ////////////////////
      EgovMap PAY0017DSEQMap = ASManagementListMapper.getPAY0017DSEQ(params);
      String PAY0017DSEQ = String.valueOf(PAY0017DSEQMap.get("seq"));
      svc0004dmap.put("ACC_INV_VOID_ID", PAY0017DSEQ);
      svc0004dmap.put("accInvVoidSubCrditNoteId", PAY0016DSEQ);
      svc0004dmap.put("accInvVoidSubCrditNote", CNNO);
      setPay17dData(svc0004dmap);
      setPay18dData(svc0004dmap);
      ////////////////// pay17d pay18d end////////////////////

      ////////////////// pay06d ////////////////////
      EgovMap pay06d_insert = new EgovMap();
      pay06d_insert.put("asId", AS_ID);
      pay06d_insert.put("asDocNo", CNNO);
      pay06d_insert.put("asLgDocTypeId", "155");
      pay06d_insert.put("asLgDt", new Date());
      pay06d_insert.put("asLgAmt", (((BigDecimal) resultPAY0031DInfo.get("taxInvcAmtDue")).negate()));
      pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
      pay06d_insert.put("asLgUpdDt", new Date());
      pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
      pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
      pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
      pay06d_insert.put("asAdvPay", "0");
      pay06d_insert.put("r01", "");
      // 4
      int reverse_PAY0006D_cnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
      ////////////////// pay06d end////////////////////
    }
//
//    ////////////////// pay06d ////////////////////
//    /// Restore Advanced AS Payment Use In Current Result
//    List<EgovMap> p6dList = ASManagementListMapper.getResult_PAY0006D(svc0004dmap);
//    if (null != p6dList && p6dList.size() > 0) {
//      for (int i = 0; i < p6dList.size(); i++) {
//        EgovMap pay06d_insert = p6dList.get(i);
//
//        ////////////////// pay06d 1set ////////////////////
//        BigDecimal asLgAmt = (BigDecimal) pay06d_insert.get("asLgAmt");
//        // double p16d_asTotAmt = pay06d_insert.get("asLgAmt") ==null ? 0 :
//        // Double.parseDouble((String)pay06d_insert.get("asLgAmt") );
//        long p16d_asTotAmt = pay06d_insert.get("asLgAmt") == null ? 0 : asLgAmt.longValue();
//
//        pay06d_insert.put("asId", AS_ID);
//        pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
//        pay06d_insert.put("asLgDocTypeId", "163");
//        pay06d_insert.put("asLgDt", new Date());
//        pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
//        pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//        pay06d_insert.put("asLgUpdDt", new Date());
//        pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
//        pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
//        pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
//        pay06d_insert.put("asAdvPay", "1");
//        pay06d_insert.put("r01", "");
//        // 3
//        int reverse_PAY0006D_1setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
//        ////////////////// pay06d 1set end////////////////
//
//        ////////////////// pay06d 2set ////////////////////
//        pay06d_insert.put("asId", AS_ID);
//        pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
//        pay06d_insert.put("asLgDocTypeId", "401");
//        pay06d_insert.put("asLgDt", new Date());
//        pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
//        pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//        pay06d_insert.put("asLgUpdDt", new Date());
//        pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
//        pay06d_insert.put("asResultNo", "");
//        pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
//        pay06d_insert.put("asAdvPay", "1");
//        pay06d_insert.put("r01", "");
//        // 2
//        int reverse_PAY0006D_2setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
//        ////////////////// pay06d 2set end////////////////
//      }
//    }
//    ////////////////// pay06d end ////////////////////
//
//    // Reverse All AS Payment Transaction Including Reverse Payment,because
//    // reverse payment can be partial amount
//    List<EgovMap> p7dList = ASManagementListMapper.getResult_PAY0007D(svc0004dmap);
//    if (null != p7dList && p7dList.size() > 0) {
//
//      ////////////////// pay07d update ////////////////
//      int reverse_StateUpPAY0007D_cnt = ASManagementListMapper.reverse_StateUpPAY0007D(svc0004dmap);
//      ////////////////// pay07d update ////////////////
//
//      ////////////////// PAY0064D SELECT ////////////////
//
//      svc0004dmap.put("BILL_ID", String.valueOf((p7dList.get(0)).get("billId")));
//      List<EgovMap> p64dList = ASManagementListMapper.getResult_PAY0064D(svc0004dmap);
//      ////////////////// PAY0064D ////////////////
//      if (null != p64dList && p64dList.size() > 0) {
//        for (int i = 0; i < p64dList.size(); i++) {
//
//          EgovMap p64dList_Map = p64dList.get(i);
//          BigDecimal totAmt = (BigDecimal) p64dList_Map.get("totAmt");
//          // double trxTotAmt = p64dList_Map.get("totAmt") ==null ? 0 :
//          // Double.parseDouble((String)p64dList_Map.get("totAmt") );
//          long trxTotAmt = p64dList_Map.get("totAmt") == null ? 0 : totAmt.longValue();
//          Map PAY_DocNoMap = null;
//          String PAYNO_REV = null;
//
//          params.put("DOCNO", "82");
//          PAY_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
//          PAYNO_REV = String.valueOf(PAY_DocNoMap.get("asno"));
//
//          EgovMap PAY0069DSEQMap = ASManagementListMapper.getPAY0069DSEQ(params);
//          String PAY0069DSEQ = String.valueOf(PAY0069DSEQMap.get("seq"));
//
//          ////////////////// PAY0069D insert ////////////////
//          EgovMap pay069d_insert = new EgovMap();
//          pay069d_insert.put("trxId", PAY0069DSEQ);
//          pay069d_insert.put("trxDt", new Date());
//          pay069d_insert.put("trxType", "101");
//          pay069d_insert.put("trxAmt", (-1 * trxTotAmt));
//          pay069d_insert.put("trxMtchNo", "");
//
//          int insert_PAY0069D_cnt = ASManagementListMapper.insert_PAY0069D(pay069d_insert);
//          ////////////////// PAY0069D out ////////////////
//
//          ////////////////// PAY0064D insert ////////////////
//          EgovMap PAY0064DSEQMap = ASManagementListMapper.getPAY0064DSEQ(params);
//          String PAY0064DSEQ = String.valueOf(PAY0064DSEQMap.get("seq"));
//
//          EgovMap pay064d_insert = new EgovMap();
//          pay064d_insert.put("payId", PAY0064DSEQ);
//          pay064d_insert.put("orNo", PAYNO_REV);
//          pay064d_insert.put("salesOrdId", p64dList_Map.get("salesOrdId"));
//          pay064d_insert.put("billId", p64dList_Map.get("billId"));
//          pay064d_insert.put("trNo", p64dList_Map.get("trNo"));
//          pay064d_insert.put("typeId", "101");
//          // pay064d_insert.put("payData",new Date());
//          pay064d_insert.put("bankChgAmt", p64dList_Map.get("bankChgAmt"));
//          pay064d_insert.put("bankChgAccId", p64dList_Map.get("bankChgAccId"));
//          pay064d_insert.put("collMemId", p64dList_Map.get("collMemId"));
//          pay064d_insert.put("brnchId", params.get("brnchId"));
//          pay064d_insert.put("bankAccId", p64dList_Map.get("bankAccId"));
//          pay064d_insert.put("allowComm", p64dList_Map.get("allowComm"));
//          pay064d_insert.put("stusCodeId", "1");
//          pay064d_insert.put("updUserId", svc0004dmap.get("updator"));
//          // pay064d_insert.put("updDt",new Date());
//          pay064d_insert.put("syncHeck", "0");
//          pay064d_insert.put("custId3party", p64dList_Map.get("custId3party"));
//          // double p46TotAmt = p64dList_Map.get("totAmt") ==null ? 0 :
//          // Double.parseDouble((String)p64dList_Map.get("totAmt") );
//          pay064d_insert.put("totAmt", (-1 * trxTotAmt)); // p46TotAmt
//          pay064d_insert.put("mtchId", p64dList_Map.get("payId"));
//          pay064d_insert.put("crtUserId", svc0004dmap.get("updator"));
//          // pay064d_insert.put("crtDt",new Date());
//          pay064d_insert.put("isAllowRevMulti", "0");
//          pay064d_insert.put("isGlPostClm", "0");
//          pay064d_insert.put("glPostClmDt", "01/01/1900");
//          pay064d_insert.put("trxId", PAY0069DSEQ);
//          pay064d_insert.put("advMonth", "0");
//          pay064d_insert.put("accBillId", "0");
//          pay064d_insert.put("trIssuDt", "01/01/1900");
//          pay064d_insert.put("taxInvcIsGen", "0");
//          pay064d_insert.put("taxInvcRefNo", "");
//          pay064d_insert.put("taxInvcRefDt", "01/01/1900");
//          pay064d_insert.put("svcCntrctId", "0");
//          pay064d_insert.put("batchPayId", "0");
//          int insert_PAY0064D_cnt = ASManagementListMapper.insert_PAY0064D(pay064d_insert);
//          ////////////////// PAY0064D out ////////////////
//
//          ////////////////// PAY0065D insert ////////////////
//          svc0004dmap.put("PAY_ID", PAY0064DSEQ);
//          List<EgovMap> p65dList = ASManagementListMapper.getResult_PAY0065D(svc0004dmap);
//          EgovMap PAY0065DSEQMap = ASManagementListMapper.getPAY0065DSEQ(params);
//          String PAY0065DSEQ = String.valueOf(PAY0065DSEQMap.get("seq"));
//
//          if (null != p65dList && p65dList.size() > 0) {
//            for (int a = 0; a < p65dList.size(); a++) {
//
//              // INSER PAY0065D
//              EgovMap p65dList_Map = p65dList.get(i);
//              // double payTotAmt = p65dList_Map.get("payItmAmt") ==null ? 0 :
//              // Double.parseDouble(((String)p65dList_Map.get("payItmAmt") ));
//
//              BigDecimal totAmt65D = (BigDecimal) p65dList_Map.get("totAmt");
//              long trxTotAmt65D = p65dList_Map.get("totAmt") == null ? 0 : totAmt65D.longValue();
//
//              EgovMap pay065d_insert = new EgovMap();
//              pay065d_insert.put("payItmId", PAY0065DSEQ);
//              pay065d_insert.put("payId", PAY0064DSEQ);
//              pay065d_insert.put("payItmModeId", p65dList_Map.get("payItmModeId"));
//              pay065d_insert.put("payItmRefNo", p65dList_Map.get("payItmRefNo"));
//              pay065d_insert.put("payItmCcNo", p65dList_Map.get("payItmCcNo"));
//              pay065d_insert.put("payItmOriCcNo", p65dList_Map.get("payItmOriCcNo"));
//              pay065d_insert.put("payItmEncryptCcNo", p65dList_Map.get("payItmEncryptCcNo"));
//              pay065d_insert.put("payItmCcTypeId", p65dList_Map.get("payItmCcTypeId"));
//              pay065d_insert.put("payItmChqNo", p65dList_Map.get("payItmChqNo"));
//              pay065d_insert.put("payItmIssuBankId", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmAmt", (-1 * trxTotAmt65D)); // payTotAmt
//              pay065d_insert.put("payItmIsOnline", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmBankAccId", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmRefDt", "01/01/1900");
//              pay065d_insert.put("payItmAppvNo", p65dList_Map.get("payItmIssuBankId"));
//              pay065d_insert.put("payItmRem", "AS RESULT EDIT (REVERSE PAYMENT)");
//              pay065d_insert.put("payItmStusId", "1");
//              pay065d_insert.put("payItmIsLok", "0");
//              pay065d_insert.put("payItmCcHolderName", p65dList_Map.get("payItmCcHolderName"));
//              pay065d_insert.put("payItmCcExprDt", p65dList_Map.get("payItmCcExprDt"));
//              pay065d_insert.put("payItmBankChrgAmt", p65dList_Map.get("payItmBankChrgAmt"));
//              pay065d_insert.put("payItmIsThrdParty", p65dList_Map.get("payItmIsThrdParty"));
//              pay065d_insert.put("payItmThrdPartyIc", p65dList_Map.get("payItmThrdPartyIc"));
//              pay065d_insert.put("payItmRefItmId", p65dList_Map.get("payItmId"));
//              pay065d_insert.put("skipRecon", "0");
//
//              pay065d_insert.put("payItmBankBrnchId", "0");
//              pay065d_insert.put("payItmBankInSlipNo", "0");
//              pay065d_insert.put("payItmEftNo", "0");
//              pay065d_insert.put("payItmChqDepReciptNo", "0");
//              pay065d_insert.put("etc1", "0");
//              pay065d_insert.put("etc2", "0");
//              pay065d_insert.put("etc3", "0");
//              pay065d_insert.put("payItmGrpId", "0");
//              pay065d_insert.put("payItmBankChrgAccId", "0");
//              pay065d_insert.put("updUserId", "0");
//              pay065d_insert.put("updDt", "");
//              pay065d_insert.put("isFundTrnsfr", "0");
//              pay065d_insert.put("payItmCardTypeId", "0");
//              pay065d_insert.put("payItmCardModeId", "0");
//              pay065d_insert.put("payItmRunngNo", "");
//              pay065d_insert.put("payItmMid", "");
//
//              int insert_PAY0065D_cnt = ASManagementListMapper.insert_PAY0065D(pay065d_insert);
//
//              // INSERT PAY0009D
//              EgovMap pay09d_insert = new EgovMap();
//              pay09d_insert.put("glPostngDt", new Date());
//              pay09d_insert.put("glFiscalDt", "01/01/1900");
//              pay09d_insert.put("glBatchNo", PAY0064DSEQ);
//              pay09d_insert.put("glBatchTypeDesc", "");
//              pay09d_insert.put("glBatchTot", (-1 * trxTotAmt65D));
//              pay09d_insert.put("glReciptNo", PAYNO_REV);
//              pay09d_insert.put("glReciptTypeId", "101");
//              pay09d_insert.put("glReciptBrnchId", svc0004dmap.get("brnchId"));
//
//              if ("107".equals(p65dList_Map.get("payItmModeId"))) { // ConvertTempAccountToSettlementAccount
//                int t_payItmIssuBankId = p65dList_Map.get("payItmIssuBankId") == null ? 0
//                    : Integer.parseInt((String) p65dList_Map.get("payItmIssuBankId"));
//                pay09d_insert.put("glReciptSetlAccId", this.convertTempAccountToSettlementAccount(t_payItmIssuBankId));
//                pay09d_insert.put("glReciptAccId", p65dList_Map.get("payItmIssuBankId"));
//
//              } else {
//                int t_payItmModeId = p65dList_Map.get("payItmModeId") == null ? 0
//                    : Integer.parseInt((String) p65dList_Map.get("payItmModeId"));
//                pay09d_insert.put("glReciptAccId", this.convertAccountToTempBasedOnPayMode(t_payItmModeId)); // ConvertAccountToTempBasedOnPayMode
//                pay09d_insert.put("glReciptSetlAccId", "0");
//              }
//
//              pay09d_insert.put("glReciptItmId", PAY0065DSEQ);
//              pay09d_insert.put("glReciptItmModeId", p65dList_Map.get("payItmModeId"));
//              pay09d_insert.put("glRevrsReciptItmId", p65dList_Map.get("payItmId"));
//              pay09d_insert.put("glReciptItmAmt", (-1 * trxTotAmt65D));
//
//              double t_payItemBankChargeAmt = p65dList_Map.get("payItmBankChrgAmt") == null ? 0
//                  : Double.parseDouble(((String) p65dList_Map.get("payItmBankChrgAmt")));
//              pay09d_insert.put("glReciptItmChrg", t_payItemBankChargeAmt);
//              pay09d_insert.put("glReciptItmRclStus", "N");
//              pay09d_insert.put("glJrnlNo", "");
//              pay09d_insert.put("glAuditRef", "");
//              pay09d_insert.put("glCnvrStus", "Y");
//              pay09d_insert.put("glCnvrDt", "");
//              int insert_PAY0009D_cnt = ASManagementListMapper.insert_PAY0009D(pay09d_insert);
//            }
//          }
//
//          // INSERT PAY0006D
//          svc0004dmap.put("AS_DOC_NO", String.valueOf(p64dList_Map.get("orNo")));
//          List<EgovMap> p06dList = ASManagementListMapper.getResult_DocNo_PAY0006D(svc0004dmap);
//
//          if (null != p06dList && p06dList.size() > 0) {
//            for (int a = 0; a < p06dList.size(); a++) {
//
//              EgovMap p06dList_Map = p06dList.get(i);
//              // double asLgAmt = p06dList_Map.get("asLgAmt") ==null ? 0 :
//              // Double.parseDouble(((String)p06dList_Map.get("asLgAmt") ));
//
//              BigDecimal totAmt06D = (BigDecimal) p06dList_Map.get("totAmt");
//              long trxTotAmt06D = p06dList_Map.get("totAmt") == null ? 0 : totAmt06D.longValue();
//
//              EgovMap pay06d_insert = new EgovMap();
//
//              pay06d_insert.put("asId", AS_ID);
//              pay06d_insert.put("asDocNo", PAYNO_REV);
//              pay06d_insert.put("asLgDocTypeId", "160");
//              pay06d_insert.put("asLgDt", new Date());
//              pay06d_insert.put("asLgAmt", (trxTotAmt06D * -1)); // asLgAmt
//              pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
//              pay06d_insert.put("asLgUpdDt", new Date());
//              pay06d_insert.put("asSoNo", p06dList_Map.get("asSoNo"));
//              pay06d_insert.put("asResultNo", p06dList_Map.get("asSoNo"));
//              pay06d_insert.put("asSoId", p06dList_Map.get("asSoId"));
//              pay06d_insert.put("asAdvPay", p06dList_Map.get("asAdvPay"));
//              pay06d_insert.put("r01", "");
//              // 1
//              int reverse_PAY0006D_cnt = ASManagementListMapper.reverse_DocNo_PAY0006D(pay06d_insert);
//
//            }
//          }
//        }
//      }
//    }

    // REVERSE HAPPY CALL
    svc0004dmap.put("HC_TYPE_NO", svc0004dmap.get("AS_NO"));
    int reverse_State_CCR0001D_cnt = ASManagementListMapper.reverse_State_CCR0001D(svc0004dmap);

    // UNMAP PAYMENT
    if (ASManagementListMapper.chkPmtMap(svc0004dmap) >= 1) {
      LOGGER.debug(" =================== START TO UNMAP PAYMENT =================== ");
      // PAYMENT HAD MAPPED.
      // INSERT BACKUP
      LOGGER.debug(" =================== 1. BACKUP =================== ");
      ASManagementListMapper.bckupPAY0252T(svc0004dmap);
      // REMOVE DATA
      LOGGER.debug(" =================== 2. REMOVE =================== ");
      // ASManagementListMapper.rmvPAY0252T(svc0004dmap);
      // UPDATE STATUS
      LOGGER.debug(" =================== 3. UPDATE =================== ");
      ASManagementListMapper.updPAY0081D(svc0004dmap);
      LOGGER.debug(" =================== END TO UNMAP PAYMENT =================== ");
    }

    // REINSERT
    ((Map) params.get("asResultM")).put("AUTOINSERT", "TRUE");// hash
    EgovMap returnemp = this.asResult_insert(params);
    returnemp.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);

    boolean rst = this.insertOptFlt(params);

    // KR-OHK Barcode Save Start
    Map<String, Object> setmapEdit = new HashMap();
    setmapEdit.put("serialNo", svc0004dmap.get("SERIAL_NO"));
    setmapEdit.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
    setmapEdit.put("reqstNo", svc0004dmap.get("AS_RESULT_NO"));
    setmapEdit.put("callGbn", "AS_EDIT");
    setmapEdit.put("mobileYn", "N");
    setmapEdit.put("userId", params.get("updator"));

    servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmapEdit);

    String errCodeEdit = (String) setmapEdit.get("pErrcode");
    String errMsgEdit = (String) setmapEdit.get("pErrmsg");

    LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_EDIT ERROR CODE : " + errCodeEdit);
    LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_EDIT ERROR MSG: " + errMsgEdit);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCodeEdit)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeEdit + ":" + errMsgEdit);
    }
    // KR-OHK Barcode Save Start

    return returnemp;
  }

 /* @Override
  public void sendSms(Map<String, Object> smsList){
	//int userId = (int) smsList.get("userId");
    //SmsVO sms = new SmsVO(userId, 975);
	SmsVO sms = new SmsVO(Integer.parseInt(smsList.get("userId").toString()), 975); //TEMP ADDED BY ALEX to Test SMS Function

    sms.setMessage(smsList.get("smsMessage").toString());
    sms.setMobiles(smsList.get("smsMobileNo").toString());
    //send SMS
    SmsResult smsResult = adaptorService.sendSMS(sms);
  }*/

  @Override
  public List<EgovMap> selectWaterSrcType() {
    return ASManagementListMapper.selectWaterSrcType();
  }

  @Override
  public List<EgovMap> selectASNotMatch() {
    return ASManagementListMapper.selectASNotMatch();
  }

  @Override
  public List<EgovMap> selectReworkProj() {
    return ASManagementListMapper.selectReworkProj();
  }

  @Override
  public void insertASResultLog(String params, String reqstUrl, String asId, int userId) {
	  Map<String, Object> p = new HashMap();
	  p.put("params", params);
	  p.put("url", reqstUrl);
	  p.put("asId", asId);
	  p.put("userId", userId);
	  ASManagementListMapper.insertASResultLog(p);
  }

  @Override
  public EgovMap selectSubmissionRecords(Map<String, Object> params) {
    return ASManagementListMapper.selectSubmissionRecords(params);
  }

  public void insertInstallationAccessories (List<String> installAccList , EgovMap installResult, int userId){
  try {
	// Remove any "0" entries from the list
	  installAccList.removeIf("0"::equals);

	  LOGGER.info("### addInstallAccList : " + installAccList.toString());

    if (!installAccList.isEmpty()){

      if (CommonUtils.nvl(installResult.get("mobileYn")).toString() == "Y" || installResult.get("mobileYn").toString().equals("Y")) {
      	installResult.put("insAccRemark", "Mobile Entry");
      } else {
      	installResult.put("insAccRemark", "Add installation accessories through eTrust - AS");
      }

      for (String installAcc : installAccList) {
            // insert into SVC0140D - Installation Accessories Listing table
            EgovMap param = new EgovMap();
            param.put("resultNo", installResult.get("asEntryNo"));
            param.put("resultSoId", installResult.get("salesOrdId"));
            param.put("insAccPartId", installAcc);
            param.put("remark", installResult.get("insAccRemark"));
            param.put("crtUserId", userId);

            installationResultListMapper.insertInstallationAccessories(param);
        }
      }
  } catch (Exception e) {
    LOGGER.error("An error occurred during insertion of installation accessories.", e);
      }
  }

  @Override
  public List<EgovMap> selectInstallAccWithAsEntryId(Map<String, Object> params) {
    return ASManagementListMapper.selectInstallAccWithAsEntryId(params);
  }

	// CELESTE [20240828] - New Product External Filter Registration Enhancement [S]
  @Override
  public EgovMap selectMembershipValidity(Map<String, Object> params) {
    return ASManagementListMapper.selectMembershipValidity(params);
  }

  @Override
  public int insert_SAL0423D(Map<String, Object> params) {
    return ASManagementListMapper.insert_SAL0423D(params);
  }
	// CELESTE [20240828] - New Product External Filter Registration Enhancement [E]

}
