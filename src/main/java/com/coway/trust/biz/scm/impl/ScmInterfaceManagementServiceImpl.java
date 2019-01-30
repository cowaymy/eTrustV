/*
 * Copyright 2008-2009 the original author or authors.
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
package com.coway.trust.biz.scm.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.scm.ScmInterfaceManagementService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ScmInterfaceManagementService")
public class ScmInterfaceManagementServiceImpl implements ScmInterfaceManagementService {
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmInterfaceManagementServiceImpl.class);

	@Autowired
	private ScmInterfaceManagementMapper	scmInterfaceManagementMapper;
	@Autowired
	private ScmCommonMapper	scmCommonMapper;

	/*
	 * SCM Interface
	 */
	//	Search & etc
	@Override
	public List<EgovMap> selectInterfaceList(Map<String, Object> params) {
		String startDate	= "";
		String endDate		= "";
		
		startDate	= params.get("startDate").toString();
		endDate		= params.get("endDate").toString();
		
		startDate	= startDate.replace("/", "");	startDate	= startDate.replace(".", "");	startDate	= startDate.replace("-", "");
		endDate		= endDate.replace("/", "");		endDate		= endDate.replace(".", "");		endDate		= endDate.replace("-", "");
		
		startDate	= startDate.substring(4, 8) + startDate.substring(2, 4) + startDate.substring(0, 2);
		endDate		= endDate.substring(4, 8) + endDate.substring(2, 4) + endDate.substring(0, 2);
		
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		LOGGER.debug("startDate : " + startDate + ", endDate : " + endDate);
		
		return	scmInterfaceManagementMapper.selectInterfaceList(params);
	}
	@Override
	public int scmIf155(List<Map<String, Object>> chkList, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		int crtUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : chkList ) {
				LOGGER.debug("chkList : ", list);
				params.put("crtUserId", crtUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				scmInterfaceManagementMapper.scmIf155(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	@Override
	public int insertSCM0039M(List<Map<String, Object>> chkList, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		int crtUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : chkList ) {
				LOGGER.debug("chkList : ", list);
				params.put("crtUserId", crtUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				params.put("stockCode", list.get("stockCode"));
				params.put("poQty", list.get("poQty"));
				params.put("poItemStusId", 5);	//	5 : Approvaed
				scmInterfaceManagementMapper.insertSCM0039M(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	
	//	log
	@Override
	public void insertLog(Map<String, Object> params) {
		LOGGER.debug("insertLog : {}", params);
		scmInterfaceManagementMapper.insertLog(params);
	}
	
	//	Procedure Batch
	@Override
	public void executeProcedureBatch(Map<String, Object> params) {
		String ifType	= "";
		params.put("status", 0);
		params.put("result", "");
		
		try {
			//	do anything
			ifType	= params.get("ifType").toString();
			
			if ( "151".equals(ifType) ) {
				//	OTD SO 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "152".equals(ifType) ) {
				//	OTD GI 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "153".equals(ifType) ) {
				//	OTD PP 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "156".equals(ifType) ) {
				//	SAP 생성 PO번호 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "160".equals(ifType) ) {
				//	GR/AP 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0160(params);
			} else if ( "161".equals(ifType) ) {
				//	주문정보
				scmInterfaceManagementMapper.executeSP_SCM_0050S_INSERT(params);
			} else if ( "162".equals(ifType) ) {
				//	출고정보
				scmInterfaceManagementMapper.executeSP_SCM_0051S_INSERT(params);
				scmInterfaceManagementMapper.executeSP_SCM_0051S_INSERT_CALL(params);
			} else if ( "163".equals(ifType) ) {
				//	오버듀정보
				scmInterfaceManagementMapper.executeSP_SCM_0052S_INSERT(params);
			} else if ( "164".equals(ifType) ) {
				//	재고정보
				scmInterfaceManagementMapper.executeSP_SCM_0053S_INSERT(params);
			} else if ( "165".equals(ifType) ) {
				//	월별재고예측정보
				scmInterfaceManagementMapper.executeSP_MTH_SCM_FILTER_FRCST(params);
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	//	FTP Supply Plan RTP Batch
	@Override
	public List<EgovMap> selectTodayWeekTh(Map<String, Object> params) {
		return	scmInterfaceManagementMapper.selectTodayWeekTh(params);
	}
	@Override
	public List<EgovMap> selectScmIfSeq(Map<String, Object> params) {
		return	scmInterfaceManagementMapper.selectScmIfSeq(params);
	}
	@Override
	public void deleteSupplyPlanRtp(Map<String, Object> params) {
		scmInterfaceManagementMapper.deleteSupplyPlanRtp(params);
	}
	@Override
	public void mergeSupplyPlanRtp(Map<String, Object> params) {
		scmInterfaceManagementMapper.mergeSupplyPlanRtp(params);
	}
	@Override
	public void updateSupplyPlanRtp(Map<String, Object> params) {
		LOGGER.debug("updateSupplyPlanRtp : {}", params.toString());
		
		//	1. Variables
		int m0	= 0;	int m1	= 0;	int m2	= 0;	int m3	= 0;	int m4	= 0;
		int planYear		= 0;	int planWeek		= 0;	String stockCode	= "";
		int m0WeekCnt		= 0;	int m1WeekCnt		= 0;	int m2WeekCnt		= 0;	int m3WeekCnt		= 0;	int m4WeekCnt		= 0;
		int planFstSpltWeek	= 0;	int planWeekTh		= 0;	int planWeekSpltCnt	= 0;
		int m0FstWeek		= 0;	int m1FstWeek		= 0;	int m2FstWeek		= 0;	int m3FstWeek		= 0;	int m4FstWeek		= 0;
		int m0FstSpltWeek	= 0;	int m1FstSpltWeek	= 0;	int m2FstSpltWeek	= 0;	int m3FstSpltWeek	= 0;	int m4FstSpltWeek	= 0;
		int	updSect			= 0;
		
		//	2. Get Basic Info
		params.put("planYear", Integer.parseInt(params.get("scmYearCbBox").toString()));
		params.put("planWeek", Integer.parseInt(params.get("scmWeekCbBox").toString()));
		List<EgovMap> selectScmTotalInfo	= scmCommonMapper.selectScmTotalInfo(params);
		m0WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4WeekCnt").toString());
		planFstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planFstSpltWeek").toString());
		planWeekSpltCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekSpltCnt").toString());
		planWeekTh	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekTh").toString());
		if ( 1 == planWeekSpltCnt ) {
			updSect	= planWeekTh + 1;
		} else if ( 2 == planWeekSpltCnt ) {
			updSect	= planWeekTh;
		} else {
			LOGGER.debug("error");
		}
		LOGGER.debug("planWeekTh : " + planWeekTh + ", planWeekSpltCnt : " + planWeekSpltCnt + ", updSect : " + updSect);
		
		m0FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0FstWeek").toString());
		m1FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1FstWeek").toString());
		m2FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2FstWeek").toString());
		m3FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3FstWeek").toString());
		m4FstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4FstWeek").toString());
		m0FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0FstSpltWeek").toString());
		m1FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1FstSpltWeek").toString());
		m2FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2FstSpltWeek").toString());
		m3FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3FstSpltWeek").toString());
		m4FstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4FstSpltWeek").toString());
		
		//	3. Get update target & Supply Plan
		List<EgovMap> selectUpdateTarget	= scmInterfaceManagementMapper.selectUpdateTarget(params);
		//List<EgovMap> selectSupplyPlanPsi3	= scmInterfaceManagementMapper.selectSupplyPlanPsi3(params);
		
		//	4. Update
		Map<String, Object> insParams	= new HashMap<String, Object>();
		for ( int i = 0 ; i < selectUpdateTarget.size() ; i++ ) {
			m0	= 0;	m1	= 0;	m2	= 0;	m3	= 0;	m4	= 0;
			String rtpWeek	= "";	int rtpNo	= 1;
			String psiWeek	= "";	int psiNo	= 1;
			
			planYear	= Integer.parseInt(selectUpdateTarget.get(i).get("planYear").toString());
			planWeek	= Integer.parseInt(selectUpdateTarget.get(i).get("planWeek").toString());
			stockCode	= selectUpdateTarget.get(i).get("stockCode").toString();
			insParams.put("planYear", planYear);
			insParams.put("planWeek", planWeek);
			insParams.put("stockCode", stockCode);
			
			if ( 9999 != planYear ) {
				//	Target
				
				/*
				 * 개요
				 * - selectUpdateTarget의 w01 ~ w12는 스플릿 주차 구분이 안되어있음
				 * - selectUpdateTarget의 w01 : 수립주차 기준 바로 그 다음주       (ex 2019/4 기준 w01 = 5주차)
				 * - selectSupplyPlanPsi3의 w01 : 수립주차가 포함된 월의 가장 첫주 (ex 2019/4 기준 w01 = 1-2주차)
				 * 1) selectUpdateTarget의 w01 ~ w12에 스플릿정보 적용
				 * 2) selectUpdateTarget의 w01 ~ w12를 selectSupplyPlanPsi3와 주차가 맞도록 조정
				 * 3) 조정된 selectUpdateTarget의 각 m0 ~ m4 계산
				 * fstWeek : m0월의 첫주차
				 * planWeek : m0월의 수립주차
				 */
				
				//	m0
				for ( int w = 1 ; w < m0WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					if ( 1 == w ) {
						//	m0의 첫주차(스플릿이든 아니든) : 0
						insParams.put("w" + psiWeek, 0);
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m0월 w01주차 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						if ( w <= updSect ) {
							//	m0의 2번째 주차 ~ m0의 수립주차 : 0
							insParams.put("w" + psiWeek, 0);
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m0월 2번째 주차 ~ m0의 수립주차주차 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							if ( w == m0WeekCnt ) {
								//	m0의 마지막 주차 : 0 or selectUpdateTarget 불러옴
								LOGGER.debug("m1FstWeek : " + m1FstWeek + ", m1FstSpltWeek : " + m1FstSpltWeek);
								if ( m1FstWeek != m1FstSpltWeek ) {
									//	m1 첫주차, m1 첫스플릿주차 다른주차(스플릿) : 0
									insParams.put("w" + psiWeek, 0);
									LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1 첫주차, m1 첫스플릿주차 다른주차(스플릿) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
								} else {
									//	m1 첫주차, m1 첫스플릿주차 같은주차(스플릿아님) : selectUpdateTarget 불러옴
									rtpWeek	= String.valueOf(rtpNo);
									if ( 1 == rtpWeek.length() ) {
										rtpWeek	= "0" + rtpWeek;
									}
									m0	= m0 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
									insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
									rtpNo++;
									LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1 첫주차, m1 첫스플릿주차 같은주차(스플릿아님) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
								}
							} else {
								//	m0의 수립주차 +1주차 ~ m0의 마지막주차 -1주차
								rtpWeek	= String.valueOf(rtpNo);
								if ( 1 == rtpWeek.length() ) {
									rtpWeek	= "0" + rtpWeek;
								}
								m0	= m0 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
								insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
								rtpNo++;
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m0의 수립주차 +1주차 ~ m0의 마지막주차 -1주차 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							}
						}
					}
					psiNo++;
				}
				insParams.put("m0", m0);
				LOGGER.debug("m0 : " + m0);
				//	m1
				for ( int w = 1 ; w < m1WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					
					if ( 1 == w ) {
						//	m1의 첫주차
						if ( m1FstWeek == planWeek ) {
							//	m1의 첫주차 = 수립주차 : 0
							insParams.put("w" + psiWeek, 0);
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1의 첫주 = 수립주차 " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							//	m1의 첫주차 != 수립주차 : selectUpdateTarget 불러옴
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1의 첫주차 != 수립주차 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					} else {
						if ( w < m1WeekCnt ) {
							//	m1의 2번째주차 ~ m1 마지막주차 -1 : selectUpdateTarget 불러옴
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1의 2번째주차 ~ m1 마지막주차 -1 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							//	m1의 마지막 주차 : 0 or selectUpdateTarget 불러옴
							LOGGER.debug("m2FstWeek : " + m2FstWeek + ", m2FstSpltWeek : " + m2FstSpltWeek);
							if ( m2FstWeek != m2FstSpltWeek ) {
								//	m2 첫주차, m2 첫스플릿주차 다른주차(스플릿) : 0
								insParams.put("w" + psiWeek, 0);
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2 첫주차, m2 첫스플릿주차 다른주차(스플릿) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							} else {
								//	m2 첫주차, m2 첫스플릿주차 같은주차(스플릿아님) : selectUpdateTarget 불러옴
								rtpWeek	= String.valueOf(rtpNo);
								if ( 1 == rtpWeek.length() ) {
									rtpWeek	= "0" + rtpWeek;
								}
								m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
								insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
								rtpNo++;
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2 첫주차, m2 첫스플릿주차 같은주차(스플릿아님) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							}
						}
					}
					psiNo++;
				}
				insParams.put("m1", m1);
				LOGGER.debug("m1 : " + m1);
				//	m2
				for ( int w = 1 ; w < m2WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					
					//	m2부터는 처음부터 값 입력
					if ( w < m2WeekCnt ) {
						//	m2의 1번째주차 ~ m2 마지막주차 -1 : selectUpdateTarget 불러옴
						rtpWeek	= String.valueOf(rtpNo);
						if ( 1 == rtpWeek.length() ) {
							rtpWeek	= "0" + rtpWeek;
						}
						m2	= m2 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						rtpNo++;
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2의 1번째주차 ~ m2 마지막주차 -1 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						//	m2의 마지막 주차 : 0 or selectUpdateTarget 불러옴
						LOGGER.debug("m3FstWeek : " + m3FstWeek + ", m3FstSpltWeek : " + m3FstSpltWeek);
						if ( m3FstWeek != m3FstSpltWeek ) {
							//	m3 첫주차, m3 첫스플릿주차 다른주차(스플릿) : 0
							insParams.put("w" + psiWeek, 0);
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m3 첫주차, m3 첫스플릿주차 다른주차(스플릿) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							//	m3 첫주차, m3 첫스플릿주차 같은주차(스플릿아님) : selectUpdateTarget 불러옴
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m2	= m2 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m3 첫주차, m3 첫스플릿주차 같은주차(스플릿아님) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					}
					psiNo++;
				}
				insParams.put("m2", m2);
				LOGGER.debug("m2 : " + m2);
				//	m3
				for ( int w = 1 ; w < m3WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					
					//	m3부터는 처음부터 값 입력
					if ( w < m3WeekCnt ) {
						//	m3의 1번째주차 ~ m3 마지막주차 -1 : selectUpdateTarget 불러옴
						rtpWeek	= String.valueOf(rtpNo);
						if ( 1 == rtpWeek.length() ) {
							rtpWeek	= "0" + rtpWeek;
						}
						m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						rtpNo++;
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m3의 1번째주차 ~ m3 마지막주차 -1 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						//	m3의 마지막 주차 : 0 or selectUpdateTarget 불러옴
						LOGGER.debug("m4FstWeek : " + m4FstWeek + ", m4FstSpltWeek : " + m4FstSpltWeek);
						if ( m4FstWeek != m4FstSpltWeek ) {
							//	m4 첫주차, m4 첫스플릿주차 다른주차(스플릿) : 0
							insParams.put("w" + psiWeek, 0);
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m4 첫주차, m4 첫스플릿주차 다른주차(스플릿) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							//	m4 첫주차, m4 첫스플릿주차 같은주차(스플릿아님) : selectUpdateTarget 불러옴
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m4 첫주차, m4 첫스플릿주차 같은주차(스플릿아님) : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					}
					psiNo++;
				}
				insParams.put("m3", m3);
				LOGGER.debug("m3 : " + m3);
				//	m4 : 본사에서 넘어오는 정보가 수립주차 기준, 이후 12주간의 계획이므로 m4까지 update할 일은 없음
				insParams.put("m4", m4);
				LOGGER.debug("m4 : " + m4);
				LOGGER.debug(i + ". insParams : {}", insParams.toString());
				scmInterfaceManagementMapper.updateSupplyPlanRtp(insParams);
			} else {
				//	Not Target
				//LOGGER.debug("This Stock is not update target.");
			}
		}
	}
	
	//	FTP OTD SO Batch
	@Override
	public void updateOtdSo(Map<String, Object> params) {
		LOGGER.debug("updateOtdSo : {}", params);
		scmInterfaceManagementMapper.updateOtdSo(params);
	}
	
	//	FTP OTD PP Batch
	@Override
	public void deleteOtdPp(Map<String, Object> params) {
		LOGGER.debug("deleteOtdPp : {}", params);
		scmInterfaceManagementMapper.deleteOtdPp(params);
	}
	@Override
	public void mergeOtdPp(Map<String, Object> params) {
		LOGGER.debug("mergeOtdPp : {}", params);
		scmInterfaceManagementMapper.mergeOtdPp(params);
	}
	
	//	FTP OTD GI Batch
	@Override
	public void mergeOtdGi(Map<String, Object> params) {
		LOGGER.debug("mergeOtdGi : {}", params);
		scmInterfaceManagementMapper.mergeOtdGi(params);
	}
}