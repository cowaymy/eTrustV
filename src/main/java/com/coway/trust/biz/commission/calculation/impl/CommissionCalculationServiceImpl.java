package com.coway.trust.biz.commission.calculation.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.web.commission.CommissionConstants;

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

@Service("commissionCalculationService")
public class CommissionCalculationServiceImpl extends EgovAbstractServiceImpl implements CommissionCalculationService {

	private static final Logger logger = LoggerFactory.getLogger(CommissionCalculationServiceImpl.class);

	private static final int String = 0;

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commissionCalculationMapper")
	private CommissionCalculationMapper commissionCalculationMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * search Commssion Procedure Group List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectCommPrdGroupListl(Map<String, Object> params) {
		return commissionCalculationMapper.selectCommPrdGroupListl(params);
	}
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgCdListAll(Map<String, Object> params) {
		return commissionCalculationMapper.selectOrgCdListAll(params);
	}
	
	/**
	 * Calculation List Select 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectCalculationList(Map<String, Object> params) {
		return commissionCalculationMapper.selectCalculationList(params);
	}
	
	/**
	 * Basic Data List Select
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectBasicList(Map<String, Object> params) {
		return commissionCalculationMapper.selectBasicList(params);
	}
	/**
	 * Basic Data State Search
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectBasicStatus(Map<String, Object> params) {
		return commissionCalculationMapper.selectBasicStatus(params);
	}
	
	/**
	 * call Commission Procedure
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	 public Map<String, Object> callCommProcedure(Map<String, Object> param){
		return commissionCalculationMapper.callCommProcedure(param);
	}
	
	/**
	 * procedure Log insert
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	 public int callCommPrdLogIns(Map<String, Object> param){
		commissionCalculationMapper.callCommLogUpdate(param);
		int cnt  = commissionCalculationMapper.callCommPrdLogIns(param);
		return cnt;
	}
	
	/**
	 * procedure Last Log Extraction Search
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	 public List<EgovMap> selectCommRunningPrdLog(Map<String, Object> param){
		return commissionCalculationMapper.selectCommRunningPrdLog(param);
	}
	
	/**
	 * Commission Procedure Log Update(S/F)
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	 public void callCommPrdLogUpdate(Map<String, Object> param){
		commissionCalculationMapper.callCommLogUpdate(param);
		commissionCalculationMapper.callCommPrdLog(param);
	}
	
	/**
	 * Commission Fail Next Procedure Log Update
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	 public int callCommFailNextPrdLog(Map<String, Object> param){
		commissionCalculationMapper.callCommPrdLog(param);
		return 8;
	}
	
	/**
	 * Commssion Procedure Log List Select
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectLogList(Map<String, Object> params) {
		return commissionCalculationMapper.selectLogList(params);
	}
	
	/**
	 * Organization Gruop List Select
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrList(Map<String, Object> params) {
		return commissionCalculationMapper.selectOrgGrList(params);
	}
	
	/**
	 * calculation Data 7001 List Select (CD,CT,HP)
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int cntCMM0028D(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0028D(params);
	}
	@Override
	public List<EgovMap> selectData7001(Map<String, Object> params) {
		if(CommissionConstants.COMIS_CT.equals(params.get("codeGruop"))){
			return commissionCalculationMapper.selectCMM0028DCT(params);
		}else if(CommissionConstants.COMIS_CD.equals(params.get("codeGruop"))){
			System.out.println("%%%CD");
			return commissionCalculationMapper.selectCMM0028DCD(params);
		}else if(CommissionConstants.COMIS_HP.equals(params.get("codeGruop"))){
			return commissionCalculationMapper.selectCMM0028DHP(params);
		}else return null;
	}
	/**
	 * calculation Data 7002 List Select (CD,CT,HP)
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int cntCMM0029D(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0029D(params);
	}
	@Override
	public List<EgovMap> selectData7002(Map<String, Object> params) {
		if(CommissionConstants.COMIS_CT.equals(params.get("codeGruop"))){
			return commissionCalculationMapper.selectCMM0029DCT(params);
		}else if(CommissionConstants.COMIS_CD.equals(params.get("codeGruop"))){
			return commissionCalculationMapper.selectCMM0029DCD(params);
		}else if(CommissionConstants.COMIS_HP.equals(params.get("codeGruop"))){
			return commissionCalculationMapper.selectCMM0029DHP(params);
		}else return null;
	}
	
	/**
	 * Basic Data List Select
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int cntCMM0006T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0006T(params);
	}
	@Override
	public List<EgovMap> selectCMM0006T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0006T(params);
	}
	
	@Override
	public int cntCMM0007T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0007T(params);
	}
	@Override
	public List<EgovMap> selectCMM0007T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0007T(params);
	}
	
	@Override
	public int cntCMM0008T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0008T(params);
	}
	@Override
	public List<EgovMap> selectCMM0008T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0008T(params);
	}
	
	@Override
	public int cntCMM0009T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0009T(params);
	}
	@Override
	public List<EgovMap> selectCMM0009T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0009T(params);
	}
	
	@Override
	public int cntCMM0010T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0010T(params);
	}
	@Override
	public List<EgovMap> selectCMM0010T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0010T(params);
	}
	
	@Override
	public int cntCMM0011T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0011T(params);
	}
	@Override
	public List<EgovMap> selectCMM0011T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0011T(params);
	}
	
	@Override
	public int cntCMM0012T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0012T(params);
	}
	@Override
	public List<EgovMap> selectCMM0012T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0012T(params);
	}
	
	@Override
	public int cntCMM0013T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0013T(params);
	}
	@Override
	public List<EgovMap> selectCMM0013T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0013T(params);
	}
	
	@Override
	public int cntCMM0014T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0014T(params);
	}
	@Override
	public List<EgovMap> selectCMM0014T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0014T(params);
	}
	
	@Override
	public int cntCMM0015T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0015T(params);
	}
	@Override
	public List<EgovMap> selectCMM0015T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0015T(params);
	}
	
	@Override
	public int cntCMM0016T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0016T(params);
	}
	@Override
	public List<EgovMap> selectCMM0016T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0016T(params);
	}
	
	@Override
	public int cntCMM0017T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0017T(params);
	}
	@Override
	public List<EgovMap> selectCMM0017T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0017T(params);
	}
	
	@Override
	public int cntCMM0018T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0018T(params);
	}
	@Override
	public List<EgovMap> selectCMM0018T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0018T(params);
	}
	
	@Override
	public int cntCMM0019T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0019T(params);
	}
	@Override
	public List<EgovMap> selectCMM0019T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0019T(params);
	}
	
	@Override
	public int cntCMM0020T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0020T(params);
	}
	@Override
	public List<EgovMap> selectCMM0020T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0020T(params);
	}
	
	@Override
	public int cntCMM0021T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0021T(params);
	}
	@Override
	public List<EgovMap> selectCMM0021T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0021T(params);
	}
	
	@Override
	public int cntCMM0022T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0022T(params);
	}
	@Override
	public List<EgovMap> selectCMM0022T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0022T(params);
	}
	
	@Override
	public int cntCMM0023T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0023T(params);
	}
	@Override
	public List<EgovMap> selectCMM0023T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0023T(params);
	}
	
	@Override
	public int cntCMM0024T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0024T(params);
	}
	@Override
	public List<EgovMap> selectCMM0024T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0024T(params);
	}
	
	@Override
	public int cntCMM0025T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0025T(params);
	}
	@Override
	public List<EgovMap> selectCMM0025T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0025T(params);
	}
	
	@Override
	public int cntCMM0026T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0026T(params);
	}
	@Override
	public List<EgovMap> selectCMM0026T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0026T(params);
	}
	
	
	/**
	 * Basic Data Exclude Update 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public void udtExcludeDataCMM0006T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0006T(params);
	}
	@Override
	public void udtDataCMM0006T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0006T(params);
	}

	@Override
	public void udtExcludeDataCMM0007T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0007T(params);
	}
	@Override
	public void udtDataCMM0007T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0007T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0008T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0008T(params);
	}
	@Override
	public void udtDataCMM0008T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0008T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0009T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0009T(params);
	}
	@Override
	public void udtDataCMM0009T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0009T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0010T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0010T(params);
	}
	@Override
	public void udtDataCMM0010T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0010T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0011T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0011T(params);
	}
	@Override
	public void udtDataCMM0011T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0011T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0012T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0012T(params);
	}
	@Override
	public void udtDataCMM0012T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0012T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0013T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0013T(params);
	}
	@Override
	public void udtDataCMM0013T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0013T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0014T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0014T(params);
	}
	@Override
	public void udtDataCMM0014T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0014T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0015T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0015T(params);
	}
	@Override
	public void udtDataCMM0015T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0015T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0017T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0017T(params);
	}
	@Override
	public void udtDataCMM0017T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0017T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0018T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0018T(params);
	}
	@Override
	public void udtDataCMM0018T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0018T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0019T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0019T(params);
	}
	@Override
	public void udtDataCMM0019T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0019T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0020T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0020T(params);
	}
	@Override
	public void udtDataCMM0020T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0020T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0021T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0021T(params);
	}
	@Override
	public void udtDataCMM0021T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0021T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0022T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0022T(params);
	}
	@Override
	public void udtDataCMM0022T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0022T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0023T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0023T(params);
	}
	@Override
	public void udtDataCMM0023T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0023T(params);
	}
	
	@Override
	public void udtExcludeDataCMM0026T(Map<String, Object> params) {
		commissionCalculationMapper.udtExcludeDataCMM0026T(params);
	}
	@Override
	public void udtDataCMM0026T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0026T(params);
	}
	
	/**
	 * search coommission weekly management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectWeeklyList(Map<java.lang.String, Object> params) {	
		return commissionCalculationMapper.selectWeeklyList(params);
	}
	
	/**
	 * add coommission weekly management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public int addWeeklyCommissionGrid(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			logger.debug("update year : {}", ((Map<String, Object>) obj).get("year"));
			logger.debug("update month : {}", ((Map<String, Object>) obj).get("month"));
			logger.debug("update weeks : {}", ((Map<String, Object>) obj).get("weeks"));
			logger.debug("update startDt : {}", ((Map<String, Object>) obj).get("startDt"));
			logger.debug("update endDt : {}", ((Map<String, Object>) obj).get("endDt"));
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+commissionCalculationMapper.addWeeklyCommissionGrid((Map<String, Object>) obj);
		}
		return cnt;
	}

	/**
	 * update coommission weekly management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int udtWeeklyCommissionGrid(List<Object> udtList,String loginId) {
		
		int cnt=0;
		for (Object obj : udtList) {		
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			cnt=cnt+commissionCalculationMapper.udtWeeklyCommissionGrid((Map<String, Object>) obj);
		}
		return cnt;
	}

	

}
