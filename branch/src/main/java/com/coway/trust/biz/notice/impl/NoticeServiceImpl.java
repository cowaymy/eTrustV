package com.coway.trust.biz.notice.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.notice.NoticeService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("noticeService")
public class NoticeServiceImpl implements NoticeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeServiceImpl.class);

	@Resource(name = "noticeMapper")
	private NoticeMapper noticeMapper;

	@Override
	public List<EgovMap> getNoticeList(Map<String, Object> params) {
		return noticeMapper.noticeList(params);
	}

	@Override
	public int getNtceNOSeq() {
		return noticeMapper.getNtceNOSeq();
	}

	@Override
	public void insertNotice(Map<String, Object> params) {

		LOGGER.debug("@ntceSubject : {}", params.get("ntceSubject"));
		LOGGER.debug("@rgstUserNm : {}", params.get("rgstUserNm"));
		LOGGER.debug("@emgncyFlag : {}", params.get("emgncyFlag"));
		LOGGER.debug("@ntceStartDt : {}", params.get("ntceStartDt"));
		LOGGER.debug("@ntceEndDt : {}", params.get("ntceEndDt"));
		LOGGER.debug("@ntceCntnt : {}", params.get("ntceCntnt"));
		LOGGER.debug("@atchFileGrpId : {}", params.get("atchFileGrpId"));

		int noticeSeq = noticeMapper.getNtceNOSeq();
		params.put("noticeSeq", noticeSeq);
		noticeMapper.insertNotice(params);
	}

	@Override
	public EgovMap getNoticeInfo(Map<String, Object> params) {
		return noticeMapper.noticeInfo(params);
	}

	@Override
	public void updateNotice(Map<String, Object> params) {
		noticeMapper.updateNotice(params);
	}

	@Override
	public void updateViewCnt(Map<String, Object> params) {
		noticeMapper.updateViewCnt(params);

	}

	@Override
	public List<EgovMap> getAttachmentFileInfo(Map<String, Object> params) {
		return noticeMapper.selectAttachmentFileInfo(params);
	}

	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		return noticeMapper.selectCodeList(params);
	}

	@Override
	public void deleteNotice(Map<String, Object> params) {
		noticeMapper.deleteNotice(params);

	}

	@Override
	public boolean checkPassword(Map<String, Object> params) {
		boolean result = false;
		int cnt = noticeMapper.checkPassword(params);

		if (cnt == 1) {
			result = true;
		}

		return result;
	}

    @Override
    public List<EgovMap> selectNtfList(Map<String, Object> params) {
        return noticeMapper.selectNtfList(params);
    }

    @Override
    public void updateNtfStus(Map<String, Object> params) {
        noticeMapper.updateNtfStus(params);
    }
}
