package com.coway.trust.biz.payment.billing.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billing.service.DiscountMgmtService;
import com.coway.trust.cmmn.model.SessionVO;
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

@Service("discountMgmtService")
public class DiscountMgmtServiceImpl extends EgovAbstractServiceImpl implements DiscountMgmtService {

	private static final Logger logger = LoggerFactory.getLogger(DiscountMgmtServiceImpl.class);

	@Resource(name = "discountMgmtMapper")
	private DiscountMgmtMapper discountMgmtMapper;
	
	/**
	 * selectBasicInfo 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectBasicInfo(Map<String, Object> params) {
		return discountMgmtMapper.selectBasicInfo(params);
	}
	
	/**
	 * selectSalesOrderMById 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectSalesOrderMById(Map<String, Object> params) {
		return discountMgmtMapper.selectSalesOrderMById(params);
	}
	
	/**
	 * selectDiscountList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectDiscountList(Map<String, Object> params) {
		return discountMgmtMapper.selectDiscountList(params);
	}

	@Override
	public EgovMap saveAddDiscount(Map<String, Object> params, SessionVO sessionVO) {
		
		String contractServiceId = discountMgmtMapper.selectContractServiceId(params);
		params.put("dcStatusId", 1);
		params.put("userId", sessionVO.getUserId());
		params.put("contractId", contractServiceId);
		
		int saveResult = discountMgmtMapper.saveAddDiscount(params);
        List<EgovMap> discountList = new ArrayList<EgovMap>();
        EgovMap basicInfo = new EgovMap();
        
        if(saveResult == 1){
        	basicInfo = discountMgmtMapper.selectBasicInfo(params);
        	discountList = discountMgmtMapper.selectDiscountList(params);
        }
        
        EgovMap resultMap = new EgovMap();
        resultMap.put("discountList", discountList);
        resultMap.put("basicInfo", basicInfo);
		
		return resultMap;
	}

	@Override
	public String updDiscountEntry(Map<String, Object> params) {
		EgovMap discountEntries = discountMgmtMapper.selectDiscountEntries(params);
		String errorMessage = "";
		
		if(discountEntries.size() > 0){
			discountMgmtMapper.updDiscountEntry(params);
		}else{
			errorMessage = "No records found";
		}
		
		return errorMessage;
	}
	
	
}
