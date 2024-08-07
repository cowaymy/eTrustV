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

import com.coway.trust.biz.payment.autodebit.service.EnrollmentUpdateDVO;
import com.coway.trust.biz.payment.autodebit.service.EnrollmentUpdateMVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("enrollResultMapper")
public interface EnrollResultMapper {

	/**
	 * selectEnrollment Result List(Master Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectEnrollmentResultList(Map<String, Object> params);

	/**
	 * selectEnrollment Info(Master) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectEnrollmentInfo(int params);

	/**
	 * selectEnrollment Item(Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectEnrollmentItem(int params);

	/**
	 * EnrollmentUpdateMaster 저장
	 * @param params
	 * @return
	 */
	int selectEnrollmentItem(EnrollmentUpdateMVO params);

	/**
	 * EnrollmentUpdateMaster Key값 가져오기
	 * @param params
	 * @return
	 */
	int getPAY0058DSEQ();

	/**
	 * EnrollmentUpdateMaster값 저장하기
	 * @param params
	 * @return
	 */
	int insertUpdateMaster(EnrollmentUpdateMVO enrollMaster);

	/**
	 * EnrollmentUpdateGrid값 저장하기
	 * @param params
	 * @return
	 */
	int insertUpdateGrid(EnrollmentUpdateDVO enrollGrid);

	/**
	 * EnrollmentUpdateGrid값 수정하기
	 * @param params
	 * @return
	 */
	int callEnrollProcedure(Map params);

	/**
	 * EnrollmentUpdate결과값 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectSuccessInfo(int value);

	/**
	 * Added for eMandate-paperless bug fixes by Hui Ding - ticket no: #24033069
	 * @author HQ-HUIDING
	 * Jan 24, 2024
	 */
	EgovMap selectActiveBankCode(String bankCode);

}
