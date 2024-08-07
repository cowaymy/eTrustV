/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipRSService;
import com.coway.trust.biz.sales.order.impl.OrderListServiceImpl;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Service("membershipRSService")
public class MembershipRSServiceImpl extends EgovAbstractServiceImpl implements MembershipRSService {

	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);
	
	@Resource(name = "membershipRSMapper")
	private MembershipRSMapper membershipRSMapper;


	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Override
	public List<EgovMap> selectCnvrList(Map<String, Object> params) {
		return membershipRSMapper.selectCnvrList(params);
	}

	@Override
	public List<EgovMap> selectCnvrDetailList(Map<String, Object> params) {
		return membershipRSMapper.selectCnvrDetailList(params);
	}

	@Override
	public EgovMap selectCnvrDetail(Map<String, Object> params) {
		return membershipRSMapper.selectCnvrDetail(params);
	}
	
	@Override
	public int selectCnvrDetailCount(Map<String, Object> params) {
		return membershipRSMapper.selectCnvrDetailCount(params);
	}

	@Override
	public int updateRsStatus(Map<String, Object> params) {
		return membershipRSMapper.updateRsStatus(params);
	}

	@Override
	public List<EgovMap> checkNewCnvrList(Map<String, Object> params) {
		
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		logger.debug("gridData ============>> " + list);		

		params.put("stusFrom", formData.get("pRsCnvrStusFrom"));
		params.put("stusTo", formData.get("pRsCnvrStusTo"));
		params.put("rsCnvrRem", formData.get("pRsCnvrRem"));
		
		EgovMap result = new EgovMap();
		
		String msg = null;

		List checkList = new ArrayList();
		
		for (Object obj : list) 
		{			
			((Map<String, Object>) obj).put("userId", params.get("userId"));

			logger.debug(" >>>>> saveNewCnvrList ");
			logger.debug(" OrderNo : {}", ((Map<String, Object>) obj).get("0"));
			logger.debug(" MembershipNo : {}", ((Map<String, Object>) obj).get("1"));
			
			params.put("orderNo", ((Map<String, Object>) obj).get("0"));
			params.put("membershipNo", ((Map<String, Object>) obj).get("1"));
			params.put("defaultDate", SalesConstants.DEFAULT_DATE);
			
			if(!StringUtils.isEmpty(params.get("orderNo"))){
				
				((Map<String, Object>) obj).put("orderNo",  ((Map<String, Object>) obj).get("0"));
				((Map<String, Object>) obj).put("membershipNo",  ((Map<String, Object>) obj).get("1"));
				((Map<String, Object>) obj).put("stusFrom",  formData.get("pRsCnvrStusFrom"));
				((Map<String, Object>) obj).put("stusTo",  formData.get("pRsCnvrStusTo"));			
				((Map<String, Object>) obj).put("chkYn", "Y");
				
				//IsCheckServiceContractIsExsit
				if(membershipRSMapper.selectSRVCntrctCnt(params) <= 0){					
					msg = messageAccessor.getMessage(SalesConstants.MEM_NO) + " [" + params.get("membershipNo") + "] : " + messageAccessor.getMessage(SalesConstants.MSG_NO_MEMNO);
					((Map<String, Object>) obj).put("chkYn", "N");
					((Map<String, Object>) obj).put("errorType", "1");
					((Map<String, Object>) obj).put("msg", msg);
					checkList.add(obj);
					continue;
				}
				
				//IsCheckOrderNoContractIsSame
				String orderId = membershipRSMapper.selectOrederId(params);				
				params.put("orderId", orderId);				
				if(membershipRSMapper.selectSrvContract(params) <= 0){
					
					msg = messageAccessor.getMessage(SalesConstants.ORD_NO) + " [" + params.get("orderNo") + "] : " + messageAccessor.getMessage(SalesConstants.MSG_NO_ORDNO);
					
					((Map<String, Object>) obj).put("chkYn", "N");
					((Map<String, Object>) obj).put("errorType", "2");
					((Map<String, Object>) obj).put("msg", msg);
					checkList.add(obj);
					continue;
				}
				
				//CHECK CONTACT NO. IS CURRENT STATUS
				String status = membershipRSMapper.selectRentalStatus(params);
				if(StringUtils.isEmpty(status)){
					msg = messageAccessor.getMessage(SalesConstants.MSG_STUS_MISMATCH) + "[ " + ((Map<String, Object>) obj).get("stusFrom") + " ]";
					((Map<String, Object>) obj).put("chkYn", "N");
					((Map<String, Object>) obj).put("errorType", "3");
					((Map<String, Object>) obj).put("msg", "This order is not under "+((Map<String, Object>) obj).get("stusFrom")+ " status.");
					checkList.add(obj);
					continue;
				}else{
					((Map<String, Object>) obj).put("msg", status);
				}
				checkList.add(obj);
			}
		}
		
		return checkList;
	}
	
	@Override
	public  List<EgovMap> saveNewCnvrList(Map<String, Object> params) {
		
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");
		
		logger.debug("gridData ============>> " + list);		
		
		params.put("stusFrom", formData.get("pRsCnvrStusFrom"));
		params.put("stusTo", formData.get("pRsCnvrStusTo"));
		params.put("rsCnvrRem", formData.get("pRsCnvrRem"));
		
		EgovMap result = new EgovMap();
				
		List checkList = new ArrayList();
		
		
		int i = 0;
		int saveCnt = 0;
		
		for (Object obj : list) 
		{
			logger.debug("gridData ============>> " + checkList);	
			
			params.put("orderNo",  ((Map<String, Object>) obj).get("orderNo"));
			params.put("membershipNo",  ((Map<String, Object>) obj).get("membershipNo"));
			params.put("defaultDate", SalesConstants.DEFAULT_DATE);
			
			if(i == 0){
				params.put("docNoId", 100);
				String convertNo = membershipRSMapper.getDocNo(params);
				
				params.put("convertNo", convertNo);
				
				membershipRSMapper.insertRentalStatusM(params);
				i++;
			}				

			
			EgovMap resultData = membershipRSMapper.selectRSDtailData(params);
			
			params.put("srvCntrctId", resultData.get("srvCntrctId"));
			params.put("salesOrdId", resultData.get("salesOrdId"));
			params.put("appTypeId", resultData.get("appTypeId"));
			
			membershipRSMapper.insertRentalStatusD(params);
			((Map<String, Object>) obj).put("msg", formData.get("pRsCnvrStusTo"));		
			((Map<String, Object>) obj).put("convertNo", params.get("convertNo"));		
			saveCnt++;

			checkList.add(obj);
		}
		
		return checkList;
	}
}
