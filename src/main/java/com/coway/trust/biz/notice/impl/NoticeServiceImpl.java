package com.coway.trust.biz.notice.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.notice.NoticeService;
import com.coway.trust.biz.notice.NoticeVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("noticeService")
public class NoticeServiceImpl extends EgovAbstractServiceImpl implements NoticeService{


	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeServiceImpl.class);
	
	@Resource(name = "noticeMapper") 
	private NoticeMapper noticeMapper;
	
	
	@Override
	public List<EgovMap> noticeList(Map<String, Object> params) throws Exception {
		return noticeMapper.noticeList(params);
	}

	@Override
	public int getNtceNOSeq() throws Exception {
		return noticeMapper.getNtceNOSeq();
	}

	@Override
	public void insertNotice(Map<String, Object> params) throws Exception {
		
		LOGGER.debug("@ntceSubject : {}", params.get("ntceSubject"));
		LOGGER.debug("@rgstUserNm : {}", params.get("rgstUserNm"));
		LOGGER.debug("@emgncyFlag : {}", params.get("emgncyFlag"));
		LOGGER.debug("@ntceStartDt : {}", params.get("ntceStartDt"));
		LOGGER.debug("@ntceEndDt : {}", params.get("ntceEndDt"));
		LOGGER.debug("@ntceCntnt : {}", params.get("ntceCntnt"));
		LOGGER.debug("@atchFileGrpId : {}", params.get("atchFileGrpId"));
		
		
		int noticeSeq = noticeMapper.getNtceNOSeq();
		
		String ntceSubject = (String) params.get("ntceSubject");
		String rgstUserNm = (String) params.get("userName");
		String emgncyFlag = (String) params.get("emgncyFlag");
		String password = (String) params.get("password");
		String ntceStartDt = (String) params.get("ntceStartDt");
		String ntceEndDt = (String) params.get("ntceEndDt");
		String ntceCntnt = (String) params.get("ntceCntnt");
		String atchFileGrpId = (String) params.get("atchFileGrpId");
		
		params.put("noticeSeq", noticeSeq);
		params.put("ntceSubject", ntceSubject);
		params.put("rgstUserNm", rgstUserNm);
		params.put("emgncyFlag", emgncyFlag);
		params.put("password", password);
		params.put("ntceStartDt", ntceStartDt);
		params.put("ntceEndDt", ntceEndDt);
		params.put("ntceCntnt", ntceCntnt);
		params.put("atchFileGrpId", atchFileGrpId);
		
		noticeMapper.insertNotice(params);
		
	}

	@Override
	public EgovMap noticeInfo(Map<String, Object> params) throws Exception {
		return noticeMapper.noticeInfo(params);
	}

	@Override
	public void updateNotice(Map<String, Object> params) throws Exception {
		noticeMapper.updateNotice(params);
	}

	@Override
	public void upViewCnt(Map<String, Object> params) throws Exception {
		noticeMapper.upViewCnt(params);
		
	}
	
	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) throws Exception {
		return noticeMapper.selectCodeList(params);
	}

	@Override
	public void deleteNotice(int ntceNo) throws Exception {
		// TODO Auto-generated method stub
		
	}

//	@Override
//	public EgovMap getAttachmentFileInfo(Map<String, Object> params) throws Exception {
//		// TODO Auto-generated method stub
//		return noticeMapper.getAttachmentFileInfo(params);
//	}
	
	
	
	
}
