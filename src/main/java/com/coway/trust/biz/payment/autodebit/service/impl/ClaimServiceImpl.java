package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.autodebit.service.ClaimService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.web.payment.autodebit.controller.ClaimController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @
 *   2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *      Copyright (C) by MOPAS All right reserved.
 */

@Service("claimService")
public class ClaimServiceImpl extends EgovAbstractServiceImpl implements ClaimService {

  @Resource(name = "claimMapper")
  private ClaimMapper claimMapper;

  private static final Logger LOGGER = LoggerFactory.getLogger(ClaimServiceImpl.class);

  /**
   * Auto Debit - Claim List 리스트 조회
   *
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> selectClaimList(Map<String, Object> params) {
    return claimMapper.selectClaimList(params);
  }

  /**
   * Auto Debit - Claim Result Deactivate 처리
   *
   * @param params
   */
  @Override
  public void updateDeactivate(Map<String, Object> param) {

    claimMapper.deleteClaimResultItem(param);
    claimMapper.updateClaimResultStatus(param);

  }

  /**
   * Auto Debit - Claim 조회
   *
   * @param params
   * @return
   */
  @Override
  public EgovMap selectClaimById(Map<String, Object> params) {
    return claimMapper.selectClaimById(params);
  }

  /**
   * Auto Debit - Claim Detail List 리스트 조회Auto Debit - Claim List 리스트 조회
   *
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> selectClaimDetailById(Map<String, Object> params) {
    return claimMapper.selectClaimDetailById(params);
  }

  /**
   * Auto Debit - Claim 생성 프로시저 호출
   *
   * @param params
   */
  @Override
  public Map<String, Object> createClaim(Map<String, Object> param) {
    return claimMapper.createClaim(param);
  }

  /**
   * Auto Debit - Claim 생성 프로시저 호출
   *
   * @param params
   */
  @Override
  public Map<String, Object> createClaimCreditCard(Map<String, Object> param) {
    return claimMapper.createClaimCreditCard(param);
  }

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  @Override
  public void updateClaimResultItem(Map<String, Object> claimMap, List<Object> resultItemList) {

    claimMapper.deleteClaimResultItem(claimMap);

    // CRC Transaction 정보
    if (resultItemList.size() > 0) {
      Map<String, Object> hm = null;
      for (Object map : resultItemList) {
        hm = (HashMap<String, Object>) map;
        claimMapper.insertClaimResultItem(hm);
      }
    }
  }

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  @Override
  public EgovMap updateClaimResultItemBulk(Map<String, Object> claimMap, Map<String, Object> cvsParam)
      throws Exception {

    // 기존 데이터 삭제
    claimMapper.deleteClaimResultItem(claimMap);

    // cvs 파일 저장 처리
    List<ClaimResultUploadVO> vos = (List<ClaimResultUploadVO>) cvsParam.get("voList");

    List<Map> list = vos.stream().map(r -> {
      Map<String, Object> map = BeanConverter.toMap(r);

      map.put("refNo", r.getRefNo());
      map.put("refCode", r.getRefCode());
      map.put("id", claimMap.get("ctrlId"));
      map.put("itemId", r.getItemId());
      map.put("apprCode", r.getApprCode());

      return map;
    }).collect(Collectors.toList());

    /*
     * List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
     *
     * for (int idx = 0; idx < vos.size(); idx++) { Map<String, Object> map =
     * new HashMap<String, Object>();
     *
     * map.put("refNo", vos.get(idx).getRefNo()); map.put("refCode",
     * vos.get(idx).getRefCode()); map.put("id", claimMap.get("ctrlId"));
     * map.put("itemId", vos.get(idx).getItemId());
     *
     * list.add(idx, map); }
     */

    int size = 1000;
    int page = list.size() / size;
    int start;
    int end;

    Map<String, Object> bulkMap = new HashMap<>();
    for (int i = 0; i <= page; i++) {
      start = i * size;
      end = size;
      if (i == page) {
        end = list.size();
      }
      bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
      claimMapper.insertClaimResultItemBulk(bulkMap);
    }

    // Credit Card, ALB, CIMB가 아니면 Item 삭제한다.
    if (!"1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) && !"2".equals(String.valueOf(claimMap.get("bankId")))
        && !"3".equals(String.valueOf(claimMap.get("bankId")))) {
      claimMapper.removeItmId(claimMap);
    }

    // message 처리를 위한 값 세팅
    EgovMap resultMap = null;
    if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimMapper.selectUploadResultBank(claimMap);
    } else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
        || "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimMapper.selectUploadResultCRC(claimMap);
    }

    return resultMap;

  }

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  @Override
  public EgovMap updateClaimResultItemBulk2(Map<String, Object> claimMap, Map<String, Object> cvsParam)
      throws Exception {

    // 기존 데이터 삭제
    claimMapper.deleteClaimResultItem(claimMap);

    // cvs 파일 저장 처리
    List<ClaimResultUploadVO> vos = (List<ClaimResultUploadVO>) cvsParam.get("voList");
    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

    for (int idx = 0; idx < vos.size(); idx++) {
      Map<String, Object> map = new HashMap<String, Object>();

      map.put("refNo", vos.get(idx).getRefNo());
      map.put("refCode", vos.get(idx).getRefCode());
      map.put("id", claimMap.get("ctrlId"));
      map.put("itemId", vos.get(idx).getItemId());
      map.put("apprCode", vos.get(idx).getApprCode());

      // list.add(idx, map);

      claimMapper.insertClaimResultItem(map);
    }

    // Credit Card, ALB, CIMB가 아니면 Item 삭제한다.
    if (!"1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) && !"2".equals(String.valueOf(claimMap.get("bankId")))
        && !"3".equals(String.valueOf(claimMap.get("bankId")))) {
      claimMapper.removeItmId(claimMap);
    }

    // message 처리를 위한 값 세팅
    EgovMap resultMap = null;
    if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimMapper.selectUploadResultBank(claimMap);
    } else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
        || "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimMapper.selectUploadResultCRC(claimMap);
    }

    return resultMap;

  }

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  @Override
  public void deleteClaimResultItem(Map<String, Object> claimMap) {
    // 기존 데이터 삭제
    claimMapper.deleteClaimResultItem(claimMap);
  }

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  @Override
  public void removeItmId(Map<String, Object> claimMap) {
    // 기존 데이터 삭제
    claimMapper.removeItmId(claimMap);
  }

  @Override
  public EgovMap selectUploadResultBank(Map<String, Object> claimMap) {
    return claimMapper.selectUploadResultBank(claimMap);
  }

  @Override
  public EgovMap selectUploadResultCRC(Map<String, Object> claimMap) {
    return claimMapper.selectUploadResultCRC(claimMap);
  }

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  @Override
  public void updateClaimResultItemBulk3(Map<String, Object> claimMap, Map<String, Object> cvsParam) throws Exception {

    // 기존 데이터 삭제
    // claimMapper.deleteClaimResultItem(claimMap);

    // cvs 파일 저장 처리
    List<ClaimResultUploadVO> vos = (List<ClaimResultUploadVO>) cvsParam.get("voList");

    List<Map> list = vos.stream().map(r -> {
      Map<String, Object> map = BeanConverter.toMap(r);

      map.put("refNo", r.getRefNo());
      map.put("refCode", r.getRefCode());
      map.put("id", claimMap.get("ctrlId"));
      map.put("itemId", r.getItemId());
      map.put("apprCode", r.getApprCode());

      return map;
    }).collect(Collectors.toList());

    /*
     * List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
     *
     * for (int idx = 0; idx < vos.size(); idx++) { Map<String, Object> map =
     * new HashMap<String, Object>();
     *
     * map.put("refNo", vos.get(idx).getRefNo()); map.put("refCode",
     * vos.get(idx).getRefCode()); map.put("id", claimMap.get("ctrlId"));
     * map.put("itemId", vos.get(idx).getItemId());
     *
     * list.add(idx, map); }
     */

    int size = 500;
    int page = list.size() / size;
    int start;
    int end;

    Map<String, Object> bulkMap = new HashMap<>();
    for (int i = 0; i <= page; i++) {
      start = i * size;
      end = size;
      if (i == page) {
        end = list.size();
      }
      bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
      claimMapper.insertClaimResultItemBulk(bulkMap);
    }
  }

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  @Override
  public void updateClaimResultItemBulk4(Map<String, Object> bulkMap) throws Exception {
    claimMapper.insertClaimResultItemBulk(bulkMap);
  }

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  @Override
  public void updateClaimResultItemArrange(Map<String, Object> claimMap) throws Exception {
    claimMapper.updateClaimResultItemArrange(claimMap);
  }

  /**
   * Auto Debit - Claim Result Update Live
   *
   * @param params
   */
  @Override
  public void updateClaimResultLive(Map<String, Object> claimMap) {
    claimMapper.updateClaimResultLive(claimMap);
  }

  /**
   * Auto Debit - Claim Result Update Live
   *
   * @param params
   */
  @Override
  public void updateCreditCardResultLive(Map<String, Object> claimMap) {
    claimMapper.updateCreditCardResultLive(claimMap);
  }

  /**
   * Auto Debit - Claim Result Update NEXT DAY
   *
   * @param params
   */
  @Override
  public void updateClaimResultNextDay(Map<String, Object> claimMap) {
    claimMapper.updateClaimResultNextDay(claimMap);
  }

  /**
   * Auto Debit - Claim Fail Deduction SMS 상세 리스트 조회
   *
   * @param params
   */
  @Override
  public List<EgovMap> selectFailClaimDetailList(Map<String, Object> param) {
    return claimMapper.selectFailClaimDetailList(param);
  }

  /**
   * Auto Debit - Fail Deduction SMS 재발송 처리
   *
   * @param params
   */
  @Override
  public void sendFaileDeduction(Map<String, Object> param) {
    claimMapper.sendFaileDeduction(param);
  }

  /**
   * Claim List - Schedule Claim Batch Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @Override
  public List<EgovMap> selectScheduleClaimBatchPop(Map<String, Object> params) {
    return claimMapper.selectScheduleClaimBatchPop(params);
  }

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @Override
  public List<EgovMap> selectScheduleClaimSettingPop(Map<String, Object> params) {
    return claimMapper.selectScheduleClaimSettingPop(params);
  }

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @Override
  public int isScheduleClaimSettingPop(Map<String, Object> params) {
    return claimMapper.isScheduleClaimSettingPop(params);
  }

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 저장
   *
   * @param params
   * @param model
   * @return
   */
  @Override
  public void saveScheduleClaimSettingPop(Map<String, Object> param) {
    claimMapper.saveScheduleClaimSettingPop(param);
  }

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 삭제
   *
   * @param params
   * @param model
   * @return
   */
  @Override
  public void removeScheduleClaimSettingPop(Map<String, Object> param) {
    claimMapper.removeScheduleClaimSettingPop(param);
  }

  /**
   * Claim List - Regenerate CRC File 전체 카운트 조회
   *
   * @param params
   * @return
   */
  @Override
  public int selectClaimDetailByIdCnt(Map<String, Object> params) {
    return claimMapper.selectClaimDetailByIdCnt(params);
  }

  @Override
  public int selectCCClaimDetailByIdCnt(Map<String, Object> params) {
    return claimMapper.selectCCClaimDetailByIdCnt(params);
  }

  @Override
  public int selectClaimDetailBatchGen(Map<String, Object> params) {
    return claimMapper.selectClaimDetailBatchGen(params);
  }

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  @Override
  public void deleteClaimFileDownloadInfo(Map<String, Object> claimMap) {
    // 기존 데이터 삭제
    claimMapper.deleteClaimFileDownloadInfo(claimMap);
  }

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  @Override
  public void insertClaimFileDownloadInfo(Map<String, Object> claimMap) {
    claimMapper.insertClaimFileDownloadInfo(claimMap);
  }

  /**
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @Override
  public List<EgovMap> selectClaimFileDown(Map<String, Object> params) {
    return claimMapper.selectClaimFileDown(params);
  }

  @Override
  public List<EgovMap> selectMstConf(Map<String, Object> params) {
    return claimMapper.selectMstConf(params);
  }

  @Override
  public String selectBnkCde(String params) {
    return claimMapper.selectBnkCde(params);
  }

  @Override
  public List<EgovMap> selectSubConf(Map<String, Object> params) {
    return claimMapper.selectSubConf(params);
  }

  @Override
  public List<EgovMap> selectClmStat(Map<String, Object> param) {
    return claimMapper.selectClmStat(param);
  }

  @Override
  public List<EgovMap> selectListing(Map<String, Object> param) {
    return claimMapper.selectListing(param);
  }

  @Override
  public List<EgovMap> selectAccBank(Map<String, Object> param) {
    return claimMapper.selectAccBank(param);
  }

  @Override
  public List<EgovMap> selectVResClaimList(Map<String, Object> params) {
    return claimMapper.selectVResClaimList(params);
  }

  @Override
  public List<EgovMap> selectVResListing(Map<String, Object> param) {
    return claimMapper.selectVResListing(param);
  }

  @Override
  public Map<String, Object> createVResClaim(Map<String, Object> param) {
    return claimMapper.createVResClaim(param);
  }

  //public void saveVRescueUpdate(Map<String, Object> params) {

	// claimMapper.saveVRescueUpdate(params);
  //}

  @Override
	public int  saveVRescueUpdate(Map<String, Object> params) {

		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);


		int o=0;
  	if (updateItemList.size() > 0) {
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);

				int check = Integer.parseInt(String.valueOf(updateMap.get("btnCheck")));
				updateMap.put("userId", params.get("userId"));

			if(check == 1){
				 claimMapper.saveVRescueUpdate(updateMap) ;
			}
			}
		}


		return o ;
	}

  @Override
	public void creditCardClaimMonth2UpateFlag(Map<String, Object> params) {

		 claimMapper.updateM2UploadBulk(params);
	}

      @Override
      public int saveM2Upload(Map<String, Object> params, List<Map<String, Object>> list) {

        int sizeM2 = 1000;
        int pageM2 = list.size() / sizeM2;
        int startM2;
        int endM2;
        claimMapper.clearM2UploadBulk(params);
        Map<String, Object> bulkMap = new HashMap<>();
        for (int i = 0; i <= pageM2; i++) {
        	startM2 = i * sizeM2;
          endM2 = sizeM2;
          if (i == pageM2) {
        	  endM2 = list.size();
          }
          bulkMap.put("list", list.stream().skip(startM2).limit(endM2).collect(Collectors.toCollection(ArrayList::new)));
          claimMapper.saveM2UploadBulk(bulkMap);
        }
        return list.size();

  }

      @Override
      public List<EgovMap> orderListMonthViewPop(Map<String, Object> params) {
        return claimMapper.orderListMonthViewPop(params);
      }

      @Override
      public List<EgovMap> selectVRescueBulkList(Map<String, Object> params) {
          // TODO Auto-generated method stub
          return claimMapper.selectVRescueBulkList(params);
      }

      @Override
      public List<EgovMap> selectVRescueBulkDetails(Map<String, Object> params) {
          // TODO Auto-generated method stub
          return claimMapper.selectVRescueBulkDetails(params);
      }

      @Override
      public Map<String, Object> saveCsvVRescueBulkUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {
          // TODO Auto-generated method stub
          int masterSeq = claimMapper.selectNextBatchId();
          master.put("batchId", masterSeq);
          int mResult = claimMapper.insertVRescueBulkMaster(master); // INSERT INTO SAL0347D
          String batchNo = claimMapper.selectvRescueBatchNo(masterSeq);

          int size = 1000;
          int page = detailList.size() / size;
          int start;
          int end;

          Map<String, Object> vRescuelist = new HashMap<>();
          vRescuelist.put("batchId", masterSeq);
          vRescuelist.put("batchNo", batchNo);
          for (int i = 0; i <= page; i++) {
              start = i * size;
              end = size;

              if(i == page){
                  end = detailList.size();
              }

              vRescuelist.put("list",
                  detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              claimMapper.insertVRescueBulkDetail(vRescuelist); // INSERT INTO SAL0348D
          }

          return vRescuelist;
      }

    @Override
  	public int  saveVRescueBulkConfirm(Map<String, Object> params) {

  		List<EgovMap> rentPayIdList = claimMapper.selectRentPayIdByBchId(params);

  		LOGGER.debug("rentPayIdList =====================================>>  " + rentPayIdList);
  		int bvr=0;
    	if (rentPayIdList.size() > 0) {
  			for (int i = 0; i < rentPayIdList.size(); i++) {
  				Map<String, Object> updateMap = (Map<String, Object>) rentPayIdList.get(i);

  				updateMap.put("userId", params.get("userId"));
  				LOGGER.debug("updateMap =====================================>>  " + updateMap);
  				 claimMapper.saveVRescueUpdate(updateMap) ;
  			}

  			claimMapper.updateVRescueBulkMByBchId(params);
  			bvr = 1;
  		}

    	else {
    		bvr = 0;
    	}

  		return bvr ;
  	}

    @Override
  	public int selectUnableBulkUploadList(List<String> params)  throws Exception {

  		return claimMapper.selectUnableBulkUploadList(params);
  	}

    @Override
  	public List<EgovMap> selectUnableBulkUploadList2(Map<String, Object> params) {

  		 return claimMapper.selectUnableBulkUploadList2(params);
  	}

}
