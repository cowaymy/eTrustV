package com.coway.trust.biz.sample;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SampleService {

	/**
	 * 글을 등록한다.
	 * 
	 * @param vo
	 *            - 등록할 정보가 담긴 SampleVO
	 * @return 등록 결과
	 * @exception Exception
	 */
	String insertSample(SampleVO vo);

	String insertSample(Map<String, Object> params);

	/**
	 * 트랜잭션 롤백 예제.
	 * 
	 * @param params
	 */
	void saveTransaction(Map<String, Object> params);

	/**
	 * 트랜잭션 에러 스킵 예제.
	 * 
	 * @param params
	 */
	void saveNoRollback(Map<String, Object> params);

	/**
	 * clob 조회 예제.
	 * 
	 * @param params
	 * @return
	 */
	List<EgovMap> selectClobData(Map<String, Object> params);

	List<EgovMap> getEditor(Map<String, Object> params);

	void saveEditor(Map<String, Object> params);

	List<EgovMap> selectClobOtherData(Map<String, Object> params);

	void insertClobData(Map<String, Object> params);

	List<EgovMap> getChartData(Map<String, Object> params);
	List<EgovMap> getLineChartData(Map<String, Object> params);

	/**
	 * 글을 수정한다.
	 * 
	 * @param vo
	 *            - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	void updateSample(SampleVO vo);

	/**
	 * 글을 삭제한다.
	 * 
	 * @param vo
	 *            - 삭제할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	void deleteSample(SampleVO vo);

	/**
	 * 글을 조회한다.
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 SampleVO
	 * @return 조회한 글
	 * @exception Exception
	 */
	SampleVO selectSample(SampleVO vo);

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> selectSampleList(SampleDefaultVO searchVO);

	List<EgovMap> selectSampleList(SampleVO sampleVO);

	List<EgovMap> selectSampleList(Map<String, Object> params);

	EgovMap selectSample(Map<String, Object> params);

	/**
	 * 글 총 갯수를 조회한다. @param sampleVO @return 글 총 갯수 @exception
	 */
	int selectSampleListTotCnt(SampleVO sampleVO);
}
