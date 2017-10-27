package com.coway.trust.biz.sample.impl;

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
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("sampleService")
public class SampleServiceImpl implements SampleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "sampleMapper")
	private SampleMapper sampleMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public void saveTransaction(Map<String, Object> params) {

		// test 용입니다.
		params.put("id", "transaction.test.01");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "transaction test 01 !!!");

		sampleMapper.insertSampleByMap(params);

		// test 용입니다.
		params.put("id", "transaction.test.02");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "transaction test 02 !!!");

		sampleMapper.insertSampleByMap(params);

		// 아래의 exception으로 인해 위의 insert 가 rollback 됩니다.
		throw new ApplicationException(AppConstants.FAIL, "transaction fail Test...");
	}

	@Override
	public List<EgovMap> getEditor(Map<String, Object> params) {
		return sampleMapper.selectEditor(params);
	}

	@Override
	public void saveEditor(Map<String, Object> params) {
		sampleMapper.insertEditor(params);
	}

	@Override
	public void saveNoRollback(Map<String, Object> params) {

		// test 용입니다.
		params.put("id", "transaction.test.01");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "transaction test 01 !!!");

		sampleMapper.insertSampleByMap(params);

		// test 용입니다.
		params.put("id", "transaction.test.02");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "transaction test 02 !!!");

		sampleMapper.insertSampleByMap(params);

		try {
			// exception 발생.
			String test = null;
			if (test.equals("")) {
				LOGGER.debug("this is sample");
			}

		} catch (Exception e) {
			LOGGER.info(">> 이 에러는 무시처리함.");
		}
	}

	@Override
	public List<EgovMap> selectClobData(Map<String, Object> params) {
		return sampleMapper.selectClobData(params);
	}

	@Override
	public List<EgovMap> selectClobOtherData(Map<String, Object> params) {
		return sampleMapper.selectClobOtherData(params);
	}

	@Override
	public void insertClobData(Map<String, Object> params) {
		sampleMapper.insertClobData(params);
	}

	@Override
	public List<EgovMap> getChartData(Map<String, Object> params) {
		sampleMapper.selectChartDataProcedure(params);
		return (List<EgovMap>) params.get("chartData");
	}

	@Override
	public List<EgovMap> getLineChartData(Map<String, Object> params) {
		sampleMapper.selectLineChartDataProcedure(params);
		return (List<EgovMap>) params.get("chartData");
	}

	/**
	 * 글을 등록한다.
	 * 
	 * @param vo
	 *            - 등록할 정보가 담긴 SampleVO
	 * @return 등록 결과
	 * @exception Exception
	 */
	@Override
	public String insertSample(SampleVO vo) {
		LOGGER.debug(vo.toString());
		String id = "test001";
		vo.setId(id);
		LOGGER.debug(vo.toString());

		sampleMapper.insertSample(vo);
		return id;
	}

	@Override
	// @Transactional(propagation = Propagation.REQUIRES_NEW)
	public String insertSample(Map<String, Object> params) {
		sampleMapper.insertSampleByMap(params);
		return "";
	}

	/**
	 * 글을 수정한다.
	 * 
	 * @param vo
	 *            - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void updateSample(SampleVO vo) {
		sampleMapper.updateSample(vo);
	}

	/**
	 * 글을 삭제한다.
	 * 
	 * @param vo
	 *            - 삭제할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void deleteSample(SampleVO vo) {
		sampleMapper.deleteSample(vo);
	}

	/**
	 * 글을 조회한다.
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 SampleVO
	 * @return 조회한 글
	 * @exception Exception
	 */
	@Override
	public SampleVO selectSample(SampleVO vo) {
		SampleVO resultVO = sampleMapper.selectSampleVO(vo);
		if (resultVO == null)
			throw new ApplicationException(AppConstants.FAIL, "message....");
		return resultVO;
	}

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectSampleList(SampleDefaultVO searchVO) {
		LOGGER.debug(" appName : {}", appName);
		LOGGER.debug(" appName : {}", appName);
		// MessageSource 사용 예시.
		LOGGER.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return sampleMapper.selectSampleList(searchVO);
	}

	@Override
	public List<EgovMap> selectSampleList(SampleVO sampleVO) {
		LOGGER.debug(" appName : {}", appName);
		LOGGER.debug(" appName : {}", appName);
		// MessageSource 사용 예시.
		LOGGER.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return sampleMapper.selectSampleList(sampleVO);
	}

	@Override
	public List<EgovMap> selectSampleList(Map<String, Object> params) {
		return sampleMapper.selectSampleByParamsList(params);
	}

	@Override
	public EgovMap selectSample(Map<String, Object> params) {
		return sampleMapper.selectSample(params);
	}

	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectSampleListTotCnt(SampleVO sampleVO) {
		return sampleMapper.selectSampleListTotCnt(sampleVO);
	}
}
