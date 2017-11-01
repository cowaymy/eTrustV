package com.coway.trust.biz.commission.system.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.jsoup.helper.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.commission.system.CommissionSystemService;
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

@Service("commissionSystemService")
public class CommissionSystemServiceImpl extends EgovAbstractServiceImpl implements CommissionSystemService {

	private static final Logger logger = LoggerFactory.getLogger(CommissionSystemServiceImpl.class);

	private static final int String = 0;

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commissionSystemMapper")
	private CommissionSystemMapper commissionSystemMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * search Organization Gruop List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgGrList(params);
	}

	/**
	 * search Organization List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgList(params);
	}

	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public int addCommissionGrid(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			logger.debug("add orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("add ORG_GR_NM : {}", ((Map<String, Object>) obj).get("orgGrNm"));
			logger.debug("add ORG_CD : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("add ORG_NM : {}", ((Map<String, Object>) obj).get("orgNm"));
			logger.debug("add USE_YN : {}", ((Map<String, Object>) obj).get("useYn"));
			logger.debug("add CRT_USER_ID : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug("add UPD_USER_ID : {}", ((Map<String, Object>) obj).get("updUserId"));

			List<EgovMap> list = commissionSystemMapper.selectRuleBookMngChk((Map<String, Object>) obj);
			if (list.size() > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orgGrCd", list.get(0).get("orgGrCd"));
				params.put("orgCd", list.get(0).get("orgCd"));
				params.put("orgSeq", list.get(0).get("orgSeq"));
				params.put("updUserId", ((Map<String, Object>) obj).get("updUserId"));
				
				commissionSystemMapper.udtCommissionGridEndDt(params);
			}
			cnt=cnt+commissionSystemMapper.addCommissionGrid((Map<String, Object>) obj);
		}
		return cnt;
	}

	/**
	 * update coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int udtCommissionGrid(List<Object> udtList,String loginId) {
		
		int cnt=0;
		for (Object obj : udtList) {
			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			logger.debug("update orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("update orgGrNm : {}", ((Map<String, Object>) obj).get("orgGrNm"));
			logger.debug("update orgCd : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("update orgNm : {}", ((Map<String, Object>) obj).get("orgNm"));
			logger.debug("update useYn : {}", ((Map<String, Object>) obj).get("useYn"));
			logger.debug("update crtUserId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug("update updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));

			cnt=cnt+commissionSystemMapper.udtCommissionGridUseYn((Map<String, Object>) obj);
		}
		return cnt;
	}

	/**
	 * delete coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int delCommissionGrid(List<Object> delList,String loginId) {
		
		for (Object obj : delList) {
			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			logger.debug("delete orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("delete ORG_GR_NM : {}", ((Map<String, Object>) obj).get("orgGrNm"));
			logger.debug("delete ORG_CD : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("delete ORG_NM : {}", ((Map<String, Object>) obj).get("orgNm"));
			logger.debug("delete USE_YN : {}", ((Map<String, Object>) obj).get("useYn"));
			logger.debug("delete CRT_USER_ID : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug("delete UPD_USER_ID : {}", ((Map<String, Object>) obj).get("updUserId"));
			
			commissionSystemMapper.delCommissionGrid((Map<String, Object>) obj);
		}
		return 0;
	}

	/**
	 * search selectRuleBookMngList List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectRuleBookOrgMngList(Map<String, Object> params) {
		return commissionSystemMapper.selectRuleBookOrgMngList(params);
	}
	
	@Override
	public List<EgovMap> selectRuleValueType(Map<String, Object> params) {
		return commissionSystemMapper.selectRuleValueType(params);
	}
	
	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrCdListAll(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgGrCdListAll(params);
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
		return commissionSystemMapper.selectOrgCdListAll(params);
	}
	
	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrCdList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgGrCdList(params);
	}
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgCdList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgCdList(params);
	}
	
	/**
	 * search Organization Item List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgItemList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgItemList(params);
	}
	
	

	/**
	 * search Rule Book Item Mng List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectRuleBookItemMngList(Map<java.lang.String, Object> params) {
		return commissionSystemMapper.selectRuleBookItemMngList(params);
	}
	
	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String addCommissionItemGrid(List<Object> addList,String loginId) {	
		
		int cnt=0;
		String msg= "";
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			logger.debug("add itemCd : {}", ((Map<String, Object>) obj).get("itemCd"));
			logger.debug("add itemNm : {}", ((Map<String, Object>) obj).get("itemNm"));
			logger.debug("add orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("add orgCd : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("add orgSeq : {}", ((Map<String, Object>) obj).get("orgSeq"));
			logger.debug("add ORG_CD : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("add typeCd : {}", ((Map<String, Object>) obj).get("typeCd"));
			logger.debug("add useYn : {}", ((Map<String, Object>) obj).get("useYn"));
			logger.debug("add cdDs : {}", ((Map<String, Object>) obj).get("cdDs"));
			logger.debug("add CRT_USER_ID : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug("add UPD_USER_ID : {}", ((Map<String, Object>) obj).get("updUserId"));
			
			List<EgovMap> list = commissionSystemMapper.selectRuleBookItemMngChk((Map<String, Object>) obj);
			if (list.size() > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orgSeq", list.get(0).get("orgSeq"));
				params.put("itemSeq", list.get(0).get("itemSeq"));
				params.put("itemCd", list.get(0).get("itemCd"));
				params.put("endDt", CommissionConstants.COMIS_END_DT);
				params.put("updUserId", ((Map<String, Object>) obj).get("updUserId"));
				
				if(StringUtil.isNumeric(list.get(0).get("orgSeq").toString())){
					msg = "pelese only number";
					break;
				}else if(StringUtil.isNumeric(list.get(0).get("itemCd").toString())){
					msg = "pelese only number";
					break;
				}else{
					msg = "success";
					commissionSystemMapper.udtCommissionItemGridEndDt(params);
				}
			}
			if(msg.equals("")){
				break;
			}else{
				if(StringUtil.isNumeric(((Map<String, Object>) obj).get("itemCd").toString() ) ){
					msg = "pelese only number";
					break;
				}else if(StringUtil.isNumeric(((Map<String, Object>) obj).get("orgSeq").toString() ) ){
					msg = "pelese only number";
					break;
				}else{
					msg = "success";
					commissionSystemMapper.addCommissionItemGrid((Map<String, Object>) obj);
				}
			}
		}
		return msg;
	}

	/**
	 * update coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public String udtCommissionItemGrid(List<Object> udtList,String loginId) {
		
		int cnt=0;
		String msg = "success";
		for (Object obj : udtList) {
			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			logger.debug("add itemCd : {}", ((Map<String, Object>) obj).get("itemCd"));
			logger.debug("add itemNm : {}", ((Map<String, Object>) obj).get("itemNm"));
			logger.debug("add orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("add orgCd : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("add orgSeq : {}", ((Map<String, Object>) obj).get("orgSeq"));
			logger.debug("add ORG_CD : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("add typeCd : {}", ((Map<String, Object>) obj).get("typeCd"));
			logger.debug("add useYn : {}", ((Map<String, Object>) obj).get("useYn"));
			logger.debug("add cdDs : {}", ((Map<String, Object>) obj).get("cdDs"));
			logger.debug("add CRT_USER_ID : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug("add UPD_USER_ID : {}", ((Map<String, Object>) obj).get("updUserId"));

			if( StringUtil.isNumeric( (((Map<String, Object>) obj).get("itemCd")).toString() )){
				msg = "pelese only number";
				break;
			}else if( StringUtil.isNumeric( (((Map<String, Object>) obj).get("orgSeq")).toString() )){
				msg = "pelese only number";
				break;
			}else{
				commissionSystemMapper.udtCommissionItemGridUseYn((Map<String, Object>) obj);
			}
		}
		return msg;
	}

	@Override
	public int addCommissionRuleData(Map<String, Object> params,String loginId) {
		int cnt=0;
		
			params.put("endDt", CommissionConstants.COMIS_END_DT);
			params.put("crtUserId", loginId);
			params.put("updUserId", loginId);
		
			logger.debug("add itemCd : {}", params.get("itemCd"));
			logger.debug("add ruleLevel : {}", params.get("ruleLevel"));
			logger.debug("add rulePid : {}", params.get("rulePid"));
			logger.debug("add ruleNm : {}", params.get("ruleNm"));
			logger.debug("add ruleCategory : {}", params.get("ruleCategory"));
			logger.debug("add ruleOpt1 : {}", params.get("ruleOpt1"));
			logger.debug("add ruleOpt2 : {}", params.get("ruleOpt2"));
			logger.debug("add valueType : {}", params.get("valueType"));
			logger.debug("add valueTypeNm : {}", params.get("valueTypeNm"));
			logger.debug("add resultValue : {}", params.get("resultValue"));
			logger.debug("add resultValueNm : {}", params.get("resultValueNm"));
			logger.debug("add ruleDesc : {}", params.get("ruleDesc"));
			logger.debug("add endYearMonth : {}", params.get("endYearMonth"));
			logger.debug("add useYn : {}", params.get("useYn"));
			logger.debug("add crtUserId : {}", params.get("crtUserId"));
			logger.debug("add updUserId : {}", params.get("updUserId"));
			logger.debug("add versionType : {}", params.get("versionType").toString());
			

		/*	List<EgovMap> list = commissionSystemMapper.selectRuleMngChk(params);
			if (list.size() > 0) {
				Map<String, Object> updParams = new HashMap<String, Object>();
				updParams.put("ruleSeq", list.get(0).get("ruleSeq"));
				updParams.put("itemSeq", list.get(0).get("itemSeq"));
				updParams.put("itemCd", list.get(0).get("itemCd"));
				updParams.put("updUserId", loginId);
				
				commissionSystemMapper.udtCommissionRuleEndDt(params);
			}*/
			if("A".equals(params.get("versionType").toString())){
				cnt=cnt+commissionSystemMapper.addCommissionRuleData(params); //int type
			}else{
				params.put("endYearmonth", CommissionConstants.COMIS_END_DT);
				params.put("prtOrder", params.get("printOrder"));
				commissionSystemMapper.addCommVersionRuleData(params); //void type
				cnt=cnt+1;
			}
		
		return cnt;
	}
	
	@Override
	public int udtCommissionRuleData(Map<String, Object> params,String loginId) {
		int cnt=0;
		
			params.put("endDt", CommissionConstants.COMIS_END_DT);
			params.put("crtUserId", loginId);
			params.put("updUserId", loginId);
		
			logger.debug("add itemCd : {}", params.get("itemCd"));
			logger.debug("add ruleLevel : {}", params.get("ruleLevel"));
			logger.debug("add rulePid : {}", params.get("rulePid"));
			logger.debug("add ruleNm : {}", params.get("ruleNm"));
			logger.debug("add ruleCategory : {}", params.get("ruleCategory"));
			logger.debug("add ruleOpt1 : {}", params.get("ruleOpt1"));
			logger.debug("add ruleOpt2 : {}", params.get("ruleOpt2"));
			logger.debug("add valueType : {}", params.get("valueType"));
			logger.debug("add valueTypeNm : {}", params.get("valueTypeNm"));
			logger.debug("add resultValue : {}", params.get("resultValue"));
			logger.debug("add resultValueNm : {}", params.get("resultValueNm"));
			logger.debug("add ruleDesc : {}", params.get("ruleDesc"));
			logger.debug("add endYearMonth : {}", params.get("endYearMonth"));
			logger.debug("add useYn : {}", params.get("useYn"));
			logger.debug("add crtUserId : {}", params.get("crtUserId"));
			logger.debug("add updUserId : {}", params.get("updUserId"));
			
			if( params.get("rulePid")==null ||  params.get("rulePid").equals("")){
				params.put("rulePid", "0");
			}
			
			System.out.println(" ** 2. type : " + params.get("versionType"));
			if("A".equals(params.get("versionType").toString())){
    			List<EgovMap> list = commissionSystemMapper.selectRuleMngChk(params);
    			if (list.size() > 0) {
    				Map<String, Object> updParams = new HashMap<String, Object>();
    				updParams.put("ruleSeq", list.get(0).get("ruleSeq"));
    				updParams.put("itemSeq", list.get(0).get("itemSeq"));
    				updParams.put("itemCd", list.get(0).get("itemCd"));
    				updParams.put("updUserId", loginId);
    				params.put("ruleLevel", list.get(0).get("ruleLevel"));
    				
    				commissionSystemMapper.udtCommissionRuleEndDt(params);
    			}
    			cnt=cnt+commissionSystemMapper.addCommissionRuleData(params);
			}else{
				List<EgovMap> list = commissionSystemMapper.selectSimulRuleMngChk(params);
    			if (list.size() > 0) {
    				params.put("ruleLevel", list.get(0).get("ruleLevel"));
    				params.put("loginId", loginId);
    				
    				commissionSystemMapper.udtCommVersionRuleEndDt(params);
    			}
    			params.put("endYearmonth", CommissionConstants.COMIS_END_DT);
    			params.put("prtOrder", params.get("printOrder"));
    			commissionSystemMapper.addCommVersionRuleData(params);
    			cnt=cnt+1;
			}
		
		return cnt;
	}

	@Override
	public List<EgovMap> selectRuleBookMngList(Map<java.lang.String, Object> params) {		
		List<EgovMap> ruleList = null;
		System.out.println("Rule Version Type : " + params.get("versionType"));
		if("A".equals(params.get("versionType")) ){
			ruleList =commissionSystemMapper.selectRuleBookMngList(params);
		}else{
			ruleList =commissionSystemMapper.selectVersionRuleBookMngList(params);
		}
		return ruleList;
		//return commissionSystemMapper.selectRuleBookMngList(params);
	}
	
	@Override
	public int cntUpdateDate(Map<String, Object> params) {
		int cnt=0;
		if("A".equals(params.get("versionType")) ){
			cnt=commissionSystemMapper.cntUpdateData(params);
		}else{
			cnt=commissionSystemMapper.cntSimulUpdateData(params);
		}
		return cnt;
	}
	@Override
	public void udtCommissionRuleData(Map<String, Object> params) {
		if("A".equals(params.get("versionType")) ){
			commissionSystemMapper.udtRuleDescData(params);
		}else{
			commissionSystemMapper.udtSimulRuleDescData(params);
		}
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
		return commissionSystemMapper.selectWeeklyList(params);
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
			
			cnt=cnt+commissionSystemMapper.addWeeklyCommissionGrid((Map<String, Object>) obj);
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

			cnt=cnt+commissionSystemMapper.udtWeeklyCommissionGrid((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public List<EgovMap> selectSimulationMngList(Map<String, Object> params) {
		return commissionSystemMapper.selectSimulationMngList(params);
	}
	
	@Override
	public void udtVersionItemEndDt (Map<String, Object> params){
		commissionSystemMapper.udtVersionItemEndDt(params);
	}
	
	@Override
	public String varsionVaildSearch (String itemCd){
		return commissionSystemMapper.varsionVaildSearch(itemCd);
	}
	
	@Override
	public void versionItemInsert(Map<String, Object> params){
		commissionSystemMapper.versionItemInsert(params);
	}
	
	@Override
	public List<EgovMap> selectVersionRuleBookList(Map<String, Object> params){
		return commissionSystemMapper.selectVersionRuleBookList(params);
	}
	
	@Override
	public void addCommVersionRuleData(Map<String, Object> params){
		commissionSystemMapper.addCommVersionRuleData(params);
	}
	
	@Override
	public void udtCommVersionRuleEndDt(Map<String, Object> params){
		commissionSystemMapper.udtCommVersionRuleEndDt(params);
	}

}
