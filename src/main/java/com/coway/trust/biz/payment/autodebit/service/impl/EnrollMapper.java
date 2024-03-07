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
package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("enrollMapper")
public interface EnrollMapper {


	/**
	 * EnrollmentList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectEnrollmentList(Map<String, Object> params);

	/**
	 * 글 상세조회를 한다. Enroll Info
	 *
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return
	 * @exception Exception
	 */
	EgovMap selectViewEnrollment(Map<String, Object> params);

	/**
	 * 글 상세조회를 한다. Enroll Info List
	 * @param params
	 * @return
	 */
    List<EgovMap> selectViewEnrollmentList(Map<String, Object> params);

    /**
	 * Save Enroll
	 *
	 * @param
	 * @return
	 * @exception Exception
	 */
    Map<String, Object> saveEnroll(Map<String, Object> param);

    /**
	 * EnrollmentDetView
	 * @param params
	 * @return
	 */
    List<EgovMap> selectEnrollmentDetView(Map<String, Object> params);


}
