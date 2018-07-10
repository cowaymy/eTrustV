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

import com.coway.trust.biz.payment.autodebit.service.ClaimService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("claimService")
public class ClaimServiceImpl extends EgovAbstractServiceImpl implements ClaimService {

	@Resource(name = "claimMapper")
	private ClaimMapper claimMapper;

	/**
	 * Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectClaimList(Map<String, Object> params) {
		return claimMapper.selectClaimList(params);
	}


	/**
     * Auto Debit - Claim Result Deactivate 처리
     * @param params
     */
	@Override
    public void updateDeactivate(Map<String, Object> param){

		claimMapper.deleteClaimResultItem(param);
		claimMapper.updateClaimResultStatus(param);

	}

	/**
	 * Auto Debit - Claim 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectClaimById(Map<String, Object> params) {
		return claimMapper.selectClaimById(params);
	}

	/**Auto Debit - Claim Detail List 리스트 조회Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectClaimDetailById(Map<String, Object> params) {
		return claimMapper.selectClaimDetailById(params);
	}

	/**
     * Auto Debit - Claim 생성 프로시저 호출
     * @param params
     */
	@Override
    public Map<String, Object> createClaim(Map<String, Object> param){
		return claimMapper.createClaim(param);
	}

	/**
     * Auto Debit - Claim 생성 프로시저 호출
     * @param params
     */
	@Override
    public Map<String, Object> createClaimCreditCard(Map<String, Object> param){
		return claimMapper.createClaimCreditCard(param);
	}


	 /**
     * Auto Debit - Claim Result Update
     * @param params
     */
	@Override
    public void updateClaimResultItem(Map<String, Object> claimMap, List<Object> resultItemList ){

		claimMapper.deleteClaimResultItem(claimMap);

		//CRC Transaction 정보
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
     * @param params
     */
	@Override
	public EgovMap updateClaimResultItemBulk(Map<String, Object> claimMap , Map<String, Object> cvsParam) throws Exception{

		//기존 데이터 삭제
		claimMapper.deleteClaimResultItem(claimMap);

		//cvs 파일 저장 처리
		List<ClaimResultUploadVO> vos = (List<ClaimResultUploadVO>)cvsParam.get("voList");


		List<Map> list = vos.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);

			map.put("refNo", r.getRefNo());
			map.put("refCode", r.getRefCode());
			map.put("id", claimMap.get("ctrlId"));
			map.put("itemId", r.getItemId());

			return map;
		})	.collect(Collectors.toList());

		/*
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		for (int idx = 0; idx < vos.size(); idx++) {
			Map<String, Object> map = new HashMap<String, Object>();

			map.put("refNo", vos.get(idx).getRefNo());
			map.put("refCode", vos.get(idx).getRefCode());
			map.put("id", claimMap.get("ctrlId"));
			map.put("itemId", vos.get(idx).getItemId());

			list.add(idx, map);
		}
		*/

		int size = 1000;
		int page = list.size() / size;
		int start;
		int end;

		Map<String, Object> bulkMap = new HashMap<>();
		for (int i = 0; i <= page; i++) {
			start = i * size;
			end = size;
			if(i == page){
				end = list.size();
			}
			bulkMap.put("list",
					list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
			claimMapper.insertClaimResultItemBulk(bulkMap);
		}

		// Credit Card, ALB, CIMB가 아니면 Item 삭제한다.
		if (!"1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
				&& !"2".equals(String.valueOf(claimMap.get("bankId")))
				&& !"3".equals(String.valueOf(claimMap.get("bankId")))) {
			claimMapper.removeItmId(claimMap);
		}

		// message 처리를 위한 값 세팅
		EgovMap resultMap = null;
		if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			resultMap = claimMapper.selectUploadResultBank(claimMap);
		} else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) || "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			resultMap =  claimMapper.selectUploadResultCRC(claimMap);
		}

		return resultMap;

	}





	/**
     * Auto Debit - Claim Result Update : New Version
     * @param params
     */
	@Override
	public EgovMap updateClaimResultItemBulk2(Map<String, Object> claimMap , Map<String, Object> cvsParam) throws Exception{

		//기존 데이터 삭제
		claimMapper.deleteClaimResultItem(claimMap);

		//cvs 파일 저장 처리
		List<ClaimResultUploadVO> vos = (List<ClaimResultUploadVO>)cvsParam.get("voList");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		for (int idx = 0; idx < vos.size(); idx++) {
			Map<String, Object> map = new HashMap<String, Object>();

			map.put("refNo", vos.get(idx).getRefNo());
			map.put("refCode", vos.get(idx).getRefCode());
			map.put("id", claimMap.get("ctrlId"));
			map.put("itemId", vos.get(idx).getItemId());

			//list.add(idx, map);

			claimMapper.insertClaimResultItem(map);
		}

		// Credit Card, ALB, CIMB가 아니면 Item 삭제한다.
		if (!"1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
				&& !"2".equals(String.valueOf(claimMap.get("bankId")))
				&& !"3".equals(String.valueOf(claimMap.get("bankId")))) {
			claimMapper.removeItmId(claimMap);
		}

		// message 처리를 위한 값 세팅
		EgovMap resultMap = null;
		if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			resultMap = claimMapper.selectUploadResultBank(claimMap);
		} else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) || "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			resultMap =  claimMapper.selectUploadResultCRC(claimMap);
		}

		return resultMap;

	}


	/**
     * Auto Debit - Claim Result Update
     * @param params
     */
	@Override
    public void deleteClaimResultItem(Map<String, Object> claimMap) {
		//기존 데이터 삭제
		claimMapper.deleteClaimResultItem(claimMap);
	}

	/**
     * Auto Debit - Claim Result Update
     * @param params
     */
	@Override
    public void removeItmId(Map<String, Object> claimMap) {
		//기존 데이터 삭제
		claimMapper.removeItmId(claimMap);
	}

	@Override
	public EgovMap selectUploadResultBank (Map<String, Object> claimMap){
		return claimMapper.selectUploadResultBank(claimMap);
	}

	@Override
    public EgovMap selectUploadResultCRC (Map<String, Object> claimMap){
    	return claimMapper.selectUploadResultCRC(claimMap);
    }

	/**
     * Auto Debit - Claim Result Update : New Version
     * @param params
     */
	@Override
	public void updateClaimResultItemBulk3(Map<String, Object> claimMap , Map<String, Object> cvsParam) throws Exception{

		//기존 데이터 삭제
		//claimMapper.deleteClaimResultItem(claimMap);

		//cvs 파일 저장 처리
		List<ClaimResultUploadVO> vos = (List<ClaimResultUploadVO>)cvsParam.get("voList");


		List<Map> list = vos.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);

			map.put("refNo", r.getRefNo());
			map.put("refCode", r.getRefCode());
			map.put("id", claimMap.get("ctrlId"));
			map.put("itemId", r.getItemId());

			return map;
		})	.collect(Collectors.toList());

		/*
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		for (int idx = 0; idx < vos.size(); idx++) {
			Map<String, Object> map = new HashMap<String, Object>();

			map.put("refNo", vos.get(idx).getRefNo());
			map.put("refCode", vos.get(idx).getRefCode());
			map.put("id", claimMap.get("ctrlId"));
			map.put("itemId", vos.get(idx).getItemId());

			list.add(idx, map);
		}
		*/

		int size = 500;
		int page = list.size() / size;
		int start;
		int end;

		Map<String, Object> bulkMap = new HashMap<>();
		for (int i = 0; i <= page; i++) {
			start = i * size;
			end = size;
			if(i == page){
				end = list.size();
			}
			bulkMap.put("list",
					list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
			claimMapper.insertClaimResultItemBulk(bulkMap);
		}
	}

	/**
     * Auto Debit - Claim Result Update : New Version
     * @param params
     */
	@Override
	public void updateClaimResultItemBulk4(Map<String, Object> bulkMap) throws Exception{
		claimMapper.insertClaimResultItemBulk(bulkMap);
	}


	/**
     * Auto Debit - Claim Result Update : New Version
     * @param params
     */
	@Override
	public void updateClaimResultItemArrange(Map<String, Object> claimMap) throws Exception{
		claimMapper.updateClaimResultItemArrange(claimMap);
	}

	/**
     * Auto Debit - Claim Result Update Live
     * @param params
     */
	@Override
    public void updateClaimResultLive(Map<String, Object> claimMap){
		claimMapper.updateClaimResultLive(claimMap);
	}

	/**
     * Auto Debit - Claim Result Update Live
     * @param params
     */
	@Override
    public void updateCreditCardResultLive(Map<String, Object> claimMap){
		claimMapper.updateCreditCardResultLive(claimMap);
	}

	/**
     * Auto Debit - Claim Result Update NEXT DAY
     * @param params
     */
	@Override
    public void updateClaimResultNextDay(Map<String, Object> claimMap){
		claimMapper.updateClaimResultNextDay(claimMap);
	}



	/**
     * Auto Debit - Claim Fail Deduction SMS 상세 리스트 조회
     * @param params
     */
	@Override
    public List<EgovMap> selectFailClaimDetailList(Map<String, Object> param){
		return claimMapper.selectFailClaimDetailList(param);
	}

	/**
     * Auto Debit - Fail Deduction SMS 재발송 처리
     * @param params
     */
	@Override
    public void sendFaileDeduction(Map<String, Object> param){
		claimMapper.sendFaileDeduction(param);
	}

	/**
	 * Claim List - Schedule Claim Batch Pop-up 리스트 조회
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
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
    public void saveScheduleClaimSettingPop(Map<String, Object> param){
		claimMapper.saveScheduleClaimSettingPop(param);
	}

	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 삭제
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
    public void removeScheduleClaimSettingPop(Map<String, Object> param){
		claimMapper.removeScheduleClaimSettingPop(param);
	}


	/**
	 * Claim List - Regenerate CRC File 전체 카운트 조회
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
     * @param params
     */
	@Override
    public void deleteClaimFileDownloadInfo(Map<String, Object> claimMap) {
		//기존 데이터 삭제
		claimMapper.deleteClaimFileDownloadInfo(claimMap);
	}

	/**
     * Auto Debit - Claim Result Update
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



}
