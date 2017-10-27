/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.sample.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * sample에 관한 데이터처리 매퍼 클래스
 *
 * @author 표준프레임워크센터
 * @since 2014.01.24
 * @version 1.0
 * @see
 * 
 *      <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2014.01.24        표준프레임워크센터          최초 생성
 *
 *      </pre>
 */
@Mapper("sampleMapper")
public interface SampleMapper {

	/**
	 * 글을 등록한다.
	 * 
	 * @param vo
	 *            - 등록할 정보가 담긴 SampleVO
	 * @return 등록 결과
	 * @exception Exception
	 */
	void insertSample(SampleVO vo);

	void insertSampleByMap(Map<String, Object> params);

	List<EgovMap> selectClobData(Map<String, Object> params);

	List<EgovMap> selectEditor(Map<String, Object> params);
	void insertEditor(Map<String, Object> params);

	List<EgovMap> selectClobOtherData(Map<String, Object> params);

	void selectChartDataProcedure(Map<String, Object> params);
	void selectLineChartDataProcedure(Map<String, Object> params);

	void insertClobData(Map<String, Object> params);

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
	SampleVO selectSampleVO(SampleVO vo);

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

	List<EgovMap> selectSampleByParamsList(Map<String, Object> params);

	EgovMap selectSample(Map<String, Object> params);

	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	int selectSampleListTotCnt(SampleVO sampleVO);

}
