package com.coway.trust.biz.commission.calculation.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.datasource.DataSource;
import com.coway.trust.config.datasource.DataSourceType;
import com.coway.trust.util.CommonUtils;
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
	@DataSource(value = DataSourceType.LONG_TIME)
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
	@DataSource(value = DataSourceType.LONG_TIME)
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
	@DataSource(value = DataSourceType.LONG_TIME)
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
	@DataSource(value = DataSourceType.LONG_TIME)
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
	@DataSource(value = DataSourceType.LONG_TIME)
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
		int cnt = 0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt = commissionCalculationMapper.cntCMM0028D(params);
		}else{
			cnt = commissionCalculationMapper.cntCMM0028T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectData7001(Map<String, Object> params) {
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			if(CommissionConstants.COMIS_CT.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0028DCT(params);
			}else if(CommissionConstants.COMIS_CD.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0028DCD(params);
			}else if(CommissionConstants.COMIS_HP.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0028DHP(params);
			}else return null;
		}else{
			if(CommissionConstants.COMIS_CT.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0028TCT(params);
			}else if(CommissionConstants.COMIS_CD.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0028TCD(params);
			}else if(CommissionConstants.COMIS_HP.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0028THP(params);
			}else return null;
		}
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
		int cnt= 0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt = commissionCalculationMapper.cntCMM0029D(params);
		}else{
			cnt = commissionCalculationMapper.cntCMM0029T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectData7002(Map<String, Object> params) {
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			if(CommissionConstants.COMIS_CT.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0029DCT(params);
			}else if(CommissionConstants.COMIS_CD.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0029DCD(params);
			}else if(CommissionConstants.COMIS_HP.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0029DHP(params);
			}else return null;
		}else{
			if(CommissionConstants.COMIS_CT.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0029TCT(params);
			}else if(CommissionConstants.COMIS_CD.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0029TCD(params);
			}else if(CommissionConstants.COMIS_HP.equals(params.get("codeGruop"))){
				return commissionCalculationMapper.selectCMM0029THP(params);
			}else return null;
		}
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
	@DataSource(value = DataSourceType.LONG_TIME)
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
	
	/* CT Calculation
	@Override
	public int cntCMM0018T(Map<String, Object> params) {
		int cnt =0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt = commissionCalculationMapper.cntCMM0018T(params);
		}else{
			cnt = commissionCalculationMapper.cntCMM0018T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectCMM0018T(Map<String, Object> params) {
		List<EgovMap> list =null;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			list = commissionCalculationMapper.selectCMM0018T(params);
		}else{
			list = commissionCalculationMapper.selectSimulCMM0018T(params);
		}
		return list;
	}
	
	@Override
	public int cntCMM0019T(Map<String, Object> params) {
		int cnt =0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt = commissionCalculationMapper.cntCMM0019T(params);
		}else{
			cnt = commissionCalculationMapper.cntCMM0019T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectCMM0019T(Map<String, Object> params) {
		List<EgovMap> list =null;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			list =commissionCalculationMapper.selectCMM0019T(params);
		}else{
			list =commissionCalculationMapper.selectSimulCMM0019T(params);
		}
		return list;
	}
	
	@Override
	public int cntCMM0020T(Map<String, Object> params) {
		int cnt =0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt = commissionCalculationMapper.cntCMM0020T(params);
		}else{
			cnt = commissionCalculationMapper.cntCMM0020T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectCMM0020T(Map<String, Object> params) {
		List<EgovMap> list =null;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			list = commissionCalculationMapper.selectCMM0020T(params);
		}else{
			list = commissionCalculationMapper.selectSimulCMM0020T(params);
		}
		return list;
	}
	
	@Override
	public int cntCMM0021T(Map<String, Object> params) {
		int cnt =0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt = commissionCalculationMapper.cntCMM0021T(params);
		}else{
			cnt = commissionCalculationMapper.cntCMM0021T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectCMM0021T(Map<String, Object> params) {
		List<EgovMap> list =null;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			list = commissionCalculationMapper.selectCMM0021T(params);
		}else{
			list = commissionCalculationMapper.selectSimulCMM0021T(params);
		}
		return list;
	}*/
	
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
		int cnt =0;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			cnt  = commissionCalculationMapper.cntCMM0024T(params);
		}else{
			cnt  = commissionCalculationMapper.cntCMM0024T(params);
		}
		return cnt;
	}
	@Override
	public List<EgovMap> selectCMM0024T(Map<String, Object> params) {
		List<EgovMap> list =null;
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType")) ){
			list = commissionCalculationMapper.selectCMM0024T(params);
		}else{
			list = commissionCalculationMapper.selectSimulCMM0024T(params);
		}
		return list;
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
	
	@Override
	public int cntCMM0060T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0060T(params);
	}
	@Override
	public List<EgovMap> selectCMM0060T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0060T(params);
	}
	
	@Override
	public int cntCMM0067T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0067T(params);
	}
	@Override
	public List<EgovMap> selectCMM0067T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0067T(params);
	}
	
	@Override
	public int cntCMM0068T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0068T(params);
	}
	@Override
	public List<EgovMap> selectCMM0068T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0068T(params);
	}
	
	@Override
	public int cntCMM0069T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0069T(params);
	}
	@Override
	public List<EgovMap> selectCMM0069T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0069T(params);
	}
	
	@Override
	public int cntCMM0070T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0070T(params);
	}
	@Override
	public List<EgovMap> selectCMM0070T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0070T(params);
	}
	
	@Override
	public int cntCMM0071T(Map<String, Object> params) {
		return commissionCalculationMapper.cntCMM0071T(params);
	}
	@Override
	public List<EgovMap> selectCMM0071T(Map<String, Object> params) {
		return commissionCalculationMapper.selectCMM0071T(params);
	}
	
	
	/**
	 * Basic Data Exclude Update 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public void udtDataCMM0006T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0006T(params);
	}
	@Override
	public void udtDataCMM0007T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0007T(params);
	}
	@Override
	public void udtDataCMM0008T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0008T(params);
	}
	@Override
	public void udtDataCMM0009T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0009T(params);
	}
	@Override
	public void udtDataCMM0010T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0010T(params);
	}
	@Override
	public void udtDataCMM0011T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0011T(params);
	}
	@Override
	public void udtDataCMM0012T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0012T(params);
	}
	@Override
	public void udtDataCMM0013T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0013T(params);
	}
	@Override
	public void udtDataCMM0014T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0014T(params);
	}
	@Override
	public void udtDataCMM0015T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0015T(params);
	}
	@Override
	public void udtDataCMM0017T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0017T(params);
	}
	@Override
	public void udtDataCMM0018T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0018T(params);
	}
	@Override
	public void udtDataCMM0019T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0019T(params);
	}
	@Override
	public void udtDataCMM0020T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0020T(params);
	}
	@Override
	public void udtDataCMM0021T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0021T(params);
	}
	@Override
	public void udtDataCMM0022T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0022T(params);
	}
	@Override
	public void udtDataCMM0023T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0023T(params);
	}
	@Override
	public void udtDataCMM0026T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0026T(params);
	}
	@Override
	public void udtDataCMM0060T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0060T(params);
	}
	@Override
	public void udtDataCMM0067T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0067T(params);
	}
	@Override
	public void udtDataCMM0068T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0068T(params);
	}
	@Override
	public void udtDataCMM0069T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0069T(params);
	}
	@Override
	public void udtDataCMM0070T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0070T(params);
	}
	@Override
	public void udtDataCMM0071T(Map<String, Object> params) {
		commissionCalculationMapper.udtDataCMM0071T(params);
	}

	
	
	/**
     * Adjustment Code List
     */
	@Override
	public List<EgovMap> adjustmentCodeList(Map<String, Object> params) {
		return commissionCalculationMapper.adjustmentCodeList(params);
	}
	
	/**
     * Member Code info search
     */
	@Override
	public Map<String, Object> memberInfoSearch(Map<String, Object> params) {
		return commissionCalculationMapper.memberInfoSearch(params);
	}
	
	/**
     * order number info search
     */
	@Override
	public Map<String, Object> ordNoInfoSearch(Map<String, Object> params) {
		return commissionCalculationMapper.ordNoInfoSearch(params);
	}
	
	/**
     * adjustment Insert
     */
	@Override
	public void adjustmentInsert(Map<String, Object> params) {
		commissionCalculationMapper.adjustmentInsert(params);
	}
	
	/**
     * HP NeoPro insert
     */
	@Override
	public void neoProInsert(Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		int loginId = sessionVO.getUserId();
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	
    	String dt = CommonUtils.getNowDate().substring(4,6)+"/"+CommonUtils.getNowDate().substring(0, 4);
		
		String pvMonth = dt.substring(0,2);
		int pvYear = Integer.parseInt(dt.substring(3));
		Map<String, Object> delMap = new HashMap<String, Object>();
		delMap.put("pvYear", pvYear);
		delMap.put("pvMonth", pvMonth);
		commissionCalculationMapper.neoProDel(delMap);
		
    	Map<String, Object> dataMap = null;
    	if(gridList.size() > 1){
    		for(int i=1; i<gridList.size(); i++){
    			Map<String, Object> csvMap = (Map<String, Object>) gridList.get(i);
    			dataMap = new HashMap<String, Object>();
    			
    			if(csvMap.get("0") !=null && !("".equals((csvMap.get("0").toString()).trim()))){
        			String month= csvMap.get("2").toString();
        			month=month.length()<2?"0"+month:month;
        			String days= csvMap.get("3").toString();
        			days=days.length()<2?"0"+days:days;
        			String joinDt = csvMap.get("1")+""+month+""+days;
        			
        			dataMap.put("hpCode", csvMap.get("0"));
        			dataMap.put("hpType", CommissionConstants.COMIS_NEO_TYPE);
        			dataMap.put("pvMonth", pvMonth);
        			dataMap.put("pvYear", pvYear);
        			dataMap.put("loginId", loginId);
        			dataMap.put("joinDt", joinDt);
        			dataMap.put("isNw", csvMap.get("4"));
        			
        			commissionCalculationMapper.neoProInsert(dataMap);
    			}
    		}
    	}
		
	}
	
	
	/**
     * CT Upload insert
     */
	@Override
	public void ctUploadInsert(Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		
		
		int loginId = sessionVO.getUserId();
    	
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	
    	String dt = CommonUtils.getNowDate().substring(4,6)+"/"+CommonUtils.getNowDate().substring(0, 4);
		
		int pvMonth = Integer.parseInt(dt.substring(0,2))-1;
		int pvYear = Integer.parseInt(dt.substring(3));
		
		Map<String, Object> delMap = new HashMap<String, Object>();
		delMap.put("fYear", pvYear);
		delMap.put("fMonth", pvMonth);
		commissionCalculationMapper.ctUploadDel(delMap);
		
    	Map<String, Object> dataMap = null;
    	if(gridList.size() > 1){
    		for(int i=1; i<gridList.size(); i++){
    			Map<String, Object> csvMap = (Map<String, Object>) gridList.get(i);
    			dataMap = new HashMap<String, Object>();
    			
    			if(csvMap.get("0") !=null && !("".equals((csvMap.get("0").toString()).trim()))){
    				dataMap.put("fBatchId", pvMonth+""+pvYear);
    				dataMap.put("fCtCode", csvMap.get("0"));
    				dataMap.put("fCtRank", "0");
    				dataMap.put("fCtPerFac", csvMap.get("1"));
    				dataMap.put("fCffCmplmt", "0");
    				dataMap.put("fCffCmplnt", "0");
    				dataMap.put("f3c", "0");
    				dataMap.put("fAttLat", "0");
    				dataMap.put("fAttEl", "0");
    				dataMap.put("fCffCmplnt", "0");
    				dataMap.put("fAttMc", "0");
    				dataMap.put("fDtAllow", csvMap.get("2"));
    				dataMap.put("fAdj", csvMap.get("3"));
    				dataMap.put("fCffRewrd", csvMap.get("4"));
    				dataMap.put("fYear", pvYear);
    				dataMap.put("fMonth", pvMonth);
    				
    				commissionCalculationMapper.ctUploadInsert(dataMap);
    			}
    		}
    	}
		
	}
	
	@Override
	public List<EgovMap> incentiveStatus(Map<String, Object> params) {
		return commissionCalculationMapper.incentiveStatus(params);
	}
	
	@Override
	public List<EgovMap> incentiveType(Map<String, Object> params) {
		return commissionCalculationMapper.incentiveType(params);
	}
	
	@Override
	public List<EgovMap> incentiveTargetList(Map<String, Object> params) {
		return commissionCalculationMapper.incentiveTargetList(params);
	}
	
	@Override
	public List<EgovMap> incentiveSample(Map<String, Object> params) {
		return commissionCalculationMapper.incentiveSample(params);
	}
	@Override
	public int cntUploadBatch(Map<String, Object> params) {
		return commissionCalculationMapper.cntUploadBatch(params);
	}
	@Override
	public void insertIncentiveMaster(Map<String, Object> params) {
		commissionCalculationMapper.insertIncentiveMaster(params);
	}
	@Override
	public String selectUploadId(Map<String, Object> params) {
		return commissionCalculationMapper.selectUploadId(params);
	}
	@Override
	public void insertIncentiveDetail(Map<String, Object> params) {
		commissionCalculationMapper.insertIncentiveDetail(params);
	}
	@Override
	public void callIncentiveDetail(int uploadId) {
		commissionCalculationMapper.callIncentiveDetail(uploadId);
	}
	
	@Override
	 public Map<String, Object> incentiveMasterDetail(int uploadId){
		return commissionCalculationMapper.incentiveMasterDetail(uploadId);
	}
	
	@Override
	 public int incentiveItemCnt(Map<String, Object> params){
		return commissionCalculationMapper.incentiveItemCnt(params);
	}
	
	@Override
	public List<EgovMap> incentiveItemList(Map<String, Object> params) {
		return commissionCalculationMapper.incentiveItemList(params);
	}

	@Override
	public void removeIncentiveItem(Map<String, Object> params) {
		commissionCalculationMapper.removeIncentiveItem(params);
	}
	
	@Override
	 public Map<String, Object> incentiveItemAddMem(Map<String, Object> params){
		return commissionCalculationMapper.incentiveItemAddMem(params);
	}
	@Override
	 public int cntIncentiveMem(Map<String, Object> params){
		return commissionCalculationMapper.cntIncentiveMem(params);
	}
	
	@Override
	 public int cntUploadMemberCheck(Map<String, Object> params){
		return commissionCalculationMapper.cntUploadMemberCheck(params);
	}
	@Override
	public Map<String, Object> incentiveUploadMember(Map<String, Object> params){
		return commissionCalculationMapper.incentiveUploadMember(params);
	}
	
	@Override
	public void incentiveItemInsert(Map<String, Object> params){
		commissionCalculationMapper.incentiveItemInsert(params);
	}
	@Override
	public void incentiveItemUpdate(Map<String, Object> params){
		commissionCalculationMapper.incentiveItemUpdate(params);
	}
	@Override
	public int deactivateCheck(String uploadId){
		return commissionCalculationMapper.deactivateCheck(uploadId);
	}
	
	@Override
	public void incentiveDeactivate(Map<String, Object> params){
		commissionCalculationMapper.incentiveDeactivate(params);
	}
	
	@Override
	public void callIncentiveConfirm(Map<String, Object> params){
		commissionCalculationMapper.callIncentiveConfirm(params);
	}
	
	@Override
	 public List<EgovMap> runningPrdCheck(Map<String, Object> params){
		return commissionCalculationMapper.runningPrdCheck(params);
	}
	
	@Override
	 public List<EgovMap> runPrdTimeValid(Map<String, Object> params){
		return commissionCalculationMapper.runPrdTimeValid(params);
	}
	
	@Override
	public void prdBatchSuccessHistory(Map<String, Object> params){
		commissionCalculationMapper.prdBatchSuccessHistory(params);
	}
	
}
