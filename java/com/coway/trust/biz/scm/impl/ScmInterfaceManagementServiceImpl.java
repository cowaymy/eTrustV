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
		int planYear		= 0;	int planMonth		= 0;	int planWeek		= 0;	String stockCode	= "";
		int m0WeekCnt		= 0;	int m1WeekCnt		= 0;	int m2WeekCnt		= 0;	int m3WeekCnt		= 0;	int m4WeekCnt		= 0;
		int m0FstWeek		= 0;	int m1FstWeek		= 0;	int m2FstWeek		= 0;	int m3FstWeek		= 0;	int m4FstWeek		= 0;
		String m0FstSpltYn	= "";	String m1FstSpltYn	= "";	String m2FstSpltYn	= "";	String m3FstSpltYn	= "";	String m4FstSpltYn	= "";
		int	startPoint		= 0;
		
		//	2. Get Basic Info
		List<EgovMap> selectSupplyPlanRtpCommon	= scmInterfaceManagementMapper.selectSupplyPlanRtpCommon(params);
		planYear	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("planYear").toString());
		planMonth	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("planMonth").toString());
		planWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("planWeek").toString());
		
		m0WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m4WeekCnt").toString());
		
		m0FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m0FstWeek").toString());
		m1FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m1FstWeek").toString());
		m2FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m2FstWeek").toString());
		m3FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m3FstWeek").toString());
		m4FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m4FstWeek").toString());
		
		m0FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m0FstSpltYn").toString();
		m1FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m1FstSpltYn").toString();
		m2FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m2FstSpltYn").toString();
		m3FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m3FstSpltYn").toString();
		m4FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m4FstSpltYn").toString();
		
		startPoint	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("startPoint").toString());
		
		//	3. Get update target & Supply Plan
		List<EgovMap> selectUpdateTarget	= scmInterfaceManagementMapper.selectUpdateTarget(params);
		
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
				
				//	2019.02.01 : 2019년 5주차 파일이 오면 첫 데이터는 2019년 6주차 데이터인데, +5주해서 보여줘야 하는 부분 다시 수정
				//	m0 : selectUpdateTarget.w01이 6주차이지만, +5 해서 11주차에 보여지도록 해야 하므로, m0월은 100% 무조건 0
				LOGGER.debug("========== startPoint : " + startPoint); 
				for ( int w = 1 ; w < m0WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					//	m0의 첫주차(스플릿이든 아니든) : 0
					insParams.put("w" + psiWeek, 0);
					LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m0월 전체 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					psiNo++;
				}
				insParams.put("m0", m0);
				LOGGER.debug("m0 : " + m0);
				
				//	m1 : startPoint 확인
				for ( int w = 1 ; w < m1WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					if ( startPoint > psiNo ) {
						//	startPoint보다 앞쪽이면 무조건 0
						insParams.put("w" + psiWeek, 0);
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 startPoint 앞 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						//	startPoint보다 뒤쪽이면 selectUpdateTarget 입력시작
						if ( w == m1WeekCnt ) {
							//	m1월의 가장 마지막 주차
							if ( "Y".equals(m2FstSpltYn) ) {
								//	m2월 첫주차 스플릿
								insParams.put("w" + psiWeek, 0);
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 마지막주/m2월 첫주 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							} else {
								//	m2월 첫주차 스플릿아님
								rtpWeek	= String.valueOf(rtpNo);
								if ( 1 == rtpWeek.length() ) {
									rtpWeek	= "0" + rtpWeek;
								}
								m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
								insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
								rtpNo++;
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 마지막주/m2월 첫주 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							}
						} else {
							//	m1월의 selectUpdateTarget입력 주차
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					}
					psiNo++;
				}
				insParams.put("m1", m1);
				LOGGER.debug("m1 : " + m1);
				
				//	m2 : startPoint 확인 -> m2에서 시작되는 경우도 있음
				for ( int w = 1 ; w < m2WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					if ( startPoint > psiNo ) {
						//	startPoint보다 앞쪽이면 무조건 0
						insParams.put("w" + psiWeek, 0);
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 startPoint 앞 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						//	startPoint보다 뒤쪽이면 selectUpdateTarget 입력시작
						if ( w == m2WeekCnt ) {
							//	m2월의 가장 마지막 주차
							if ( "Y".equals(m3FstSpltYn) ) {
								//	m3월 첫주차 스플릿
								insParams.put("w" + psiWeek, 0);
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 마지막주/m3월 첫주 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							} else {
								//	m3월 첫주차 스플릿아님
								rtpWeek	= String.valueOf(rtpNo);
								if ( 1 == rtpWeek.length() ) {
									rtpWeek	= "0" + rtpWeek;
								}
								m2	= m2 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
								insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
								rtpNo++;
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 마지막주/m3월 첫주 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							}
						} else {
							//	m2월의 selectUpdateTarget입력 주차
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m2	= m2 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
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
					if ( w == m3WeekCnt ) {
						//	m3의 마지막 주차 : 0 or selectUpdateTarget 불러옴
						if ( "Y".equals(m4FstSpltYn) ) {
							//	m4 첫주차 스플릿 : 0
							insParams.put("w" + psiWeek, 0);
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							//	m4 첫주차 스플릿아님 : selectUpdateTarget 불러옴
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					} else {
						//	m3월의 selectUpdateTarget입력 주차
						rtpWeek	= String.valueOf(rtpNo);
						if ( 1 == rtpWeek.length() ) {
							rtpWeek	= "0" + rtpWeek;
						}
						m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						rtpNo++;
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m3월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					}
					psiNo++;
				}
				insParams.put("m3", m3);
				LOGGER.debug("m3 : " + m3);
				
				//	m4
				for ( int w = 1 ; w < m4WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					
					//	m4부터는 처음부터 값 입력
					//if ( w == m4WeekCnt ) {
						//	m3의 마지막 주차 : 0 or selectUpdateTarget 불러옴
						//if ( "Y".equals(m4FstSpltYn) ) {
						//	//	m4 첫주차 스플릿 : 0
						//	insParams.put("w" + psiWeek, 0);
						//	LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						//} else {
							//	m4 첫주차 스플릿아님 : selectUpdateTarget 불러옴
						//	rtpWeek	= String.valueOf(rtpNo);
						//	if ( 1 == rtpWeek.length() ) {
						//		rtpWeek	= "0" + rtpWeek;
						//	}
						//	m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						//	insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						//	rtpNo++;
						//	LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						//}
					//} else {
						//	m4월의 selectUpdateTarget입력 주차 : 제일 마지막 주차가 스플릿일 수 있는데, 그냥 입력
						rtpWeek	= String.valueOf(rtpNo);
						if ( 1 == rtpWeek.length() ) {
							rtpWeek	= "0" + rtpWeek;
						}
						m4	= m4 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						rtpNo++;
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m4월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					//}
					psiNo++;
				}
				insParams.put("m4", m4);
				LOGGER.debug("m4 : " + m4);
				LOGGER.debug("insParams : {}", insParams.toString());
				scmInterfaceManagementMapper.updateSupplyPlanRtp(insParams);
			} else {
				//	Not Target
				LOGGER.debug("This Stock is not update target.");
			}
		}
	}
	@Override
	public void testSupplyPlanRtp(Map<String, Object> params) {
		LOGGER.debug("testSupplyPlanRtp : {}", params.toString());
		
		//	1. Variables
		int m0	= 0;	int m1	= 0;	int m2	= 0;	int m3	= 0;	int m4	= 0;
		int planYear		= 0;	int planMonth		= 0;	int planWeek		= 0;	String stockCode	= "";
		int m0WeekCnt		= 0;	int m1WeekCnt		= 0;	int m2WeekCnt		= 0;	int m3WeekCnt		= 0;	int m4WeekCnt		= 0;
		int m0FstWeek		= 0;	int m1FstWeek		= 0;	int m2FstWeek		= 0;	int m3FstWeek		= 0;	int m4FstWeek		= 0;
		String m0FstSpltYn	= "";	String m1FstSpltYn	= "";	String m2FstSpltYn	= "";	String m3FstSpltYn	= "";	String m4FstSpltYn	= "";
		int	startPoint		= 0;
		
		//	2. Get Basic Info
		List<EgovMap> selectSupplyPlanRtpCommon	= scmInterfaceManagementMapper.selectSupplyPlanRtpCommon(params);
		planYear	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("planYear").toString());
		planMonth	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("planMonth").toString());
		planWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("planWeek").toString());
		
		m0WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m4WeekCnt").toString());
		
		m0FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m0FstWeek").toString());
		m1FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m1FstWeek").toString());
		m2FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m2FstWeek").toString());
		m3FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m3FstWeek").toString());
		m4FstWeek	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("m4FstWeek").toString());
		
		m0FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m0FstSpltYn").toString();
		m1FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m1FstSpltYn").toString();
		m2FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m2FstSpltYn").toString();
		m3FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m3FstSpltYn").toString();
		m4FstSpltYn	= selectSupplyPlanRtpCommon.get(0).get("m4FstSpltYn").toString();
		
		startPoint	= Integer.parseInt(selectSupplyPlanRtpCommon.get(0).get("startPoint").toString());
		
		//	3. Get update target & Supply Plan
		List<EgovMap> selectUpdateTarget	= scmInterfaceManagementMapper.selectUpdateTarget(params);
		
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
				
				//	2019.02.01 : 2019년 5주차 파일이 오면 첫 데이터는 2019년 6주차 데이터인데, +5주해서 보여줘야 하는 부분 다시 수정
				//	m0 : selectUpdateTarget.w01이 6주차이지만, +5 해서 11주차에 보여지도록 해야 하므로, m0월은 100% 무조건 0
				LOGGER.debug("========== startPoint : " + startPoint); 
				for ( int w = 1 ; w < m0WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					//	m0의 첫주차(스플릿이든 아니든) : 0
					insParams.put("w" + psiWeek, 0);
					LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m0월 전체 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					psiNo++;
				}
				insParams.put("m0", m0);
				LOGGER.debug("m0 : " + m0);
				
				//	m1 : startPoint 확인
				for ( int w = 1 ; w < m1WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					if ( startPoint > psiNo ) {
						//	startPoint보다 앞쪽이면 무조건 0
						insParams.put("w" + psiWeek, 0);
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 startPoint 앞 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						//	startPoint보다 뒤쪽이면 selectUpdateTarget 입력시작
						if ( w == m1WeekCnt ) {
							//	m1월의 가장 마지막 주차
							if ( "Y".equals(m2FstSpltYn) ) {
								//	m2월 첫주차 스플릿
								insParams.put("w" + psiWeek, 0);
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 마지막주/m2월 첫주 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							} else {
								//	m2월 첫주차 스플릿아님
								rtpWeek	= String.valueOf(rtpNo);
								if ( 1 == rtpWeek.length() ) {
									rtpWeek	= "0" + rtpWeek;
								}
								m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
								insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
								rtpNo++;
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 마지막주/m2월 첫주 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							}
						} else {
							//	m1월의 selectUpdateTarget입력 주차
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m1	= m1 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m1월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					}
					psiNo++;
				}
				insParams.put("m1", m1);
				LOGGER.debug("m1 : " + m1);
				
				//	m2 : startPoint 확인 -> m2에서 시작되는 경우도 있음
				for ( int w = 1 ; w < m2WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					if ( startPoint > psiNo ) {
						//	startPoint보다 앞쪽이면 무조건 0
						insParams.put("w" + psiWeek, 0);
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 startPoint 앞 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					} else {
						//	startPoint보다 뒤쪽이면 selectUpdateTarget 입력시작
						if ( w == m2WeekCnt ) {
							//	m2월의 가장 마지막 주차
							if ( "Y".equals(m3FstSpltYn) ) {
								//	m3월 첫주차 스플릿
								insParams.put("w" + psiWeek, 0);
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 마지막주/m3월 첫주 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							} else {
								//	m3월 첫주차 스플릿아님
								rtpWeek	= String.valueOf(rtpNo);
								if ( 1 == rtpWeek.length() ) {
									rtpWeek	= "0" + rtpWeek;
								}
								m2	= m2 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
								insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
								rtpNo++;
								LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 마지막주/m3월 첫주 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
							}
						} else {
							//	m2월의 selectUpdateTarget입력 주차
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m2	= m2 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m2월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
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
					if ( w == m3WeekCnt ) {
						//	m3의 마지막 주차 : 0 or selectUpdateTarget 불러옴
						if ( "Y".equals(m4FstSpltYn) ) {
							//	m4 첫주차 스플릿 : 0
							insParams.put("w" + psiWeek, 0);
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						} else {
							//	m4 첫주차 스플릿아님 : selectUpdateTarget 불러옴
							rtpWeek	= String.valueOf(rtpNo);
							if ( 1 == rtpWeek.length() ) {
								rtpWeek	= "0" + rtpWeek;
							}
							m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
							insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
							rtpNo++;
							LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						}
					} else {
						//	m3월의 selectUpdateTarget입력 주차
						rtpWeek	= String.valueOf(rtpNo);
						if ( 1 == rtpWeek.length() ) {
							rtpWeek	= "0" + rtpWeek;
						}
						m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						rtpNo++;
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m3월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					}
					psiNo++;
				}
				insParams.put("m3", m3);
				LOGGER.debug("m3 : " + m3);
				
				//	m4
				for ( int w = 1 ; w < m4WeekCnt + 1 ; w++ ) {
					psiWeek	= String.valueOf(psiNo);
					if ( 1 == psiWeek.length() ) {
						psiWeek	= "0" + psiWeek;
					}
					
					//	m4부터는 처음부터 값 입력
					//if ( w == m4WeekCnt ) {
						//	m3의 마지막 주차 : 0 or selectUpdateTarget 불러옴
						//if ( "Y".equals(m4FstSpltYn) ) {
						//	//	m4 첫주차 스플릿 : 0
						//	insParams.put("w" + psiWeek, 0);
						//	LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						//} else {
							//	m4 첫주차 스플릿아님 : selectUpdateTarget 불러옴
						//	rtpWeek	= String.valueOf(rtpNo);
						//	if ( 1 == rtpWeek.length() ) {
						//		rtpWeek	= "0" + rtpWeek;
						//	}
						//	m3	= m3 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						//	insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						//	rtpNo++;
						//	LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + "m3월 마지막주/m4월 첫주차 스플릿아님 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
						//}
					//} else {
						//	m4월의 selectUpdateTarget입력 주차 : 제일 마지막 주차가 스플릿일 수 있는데, 그냥 입력
						rtpWeek	= String.valueOf(rtpNo);
						if ( 1 == rtpWeek.length() ) {
							rtpWeek	= "0" + rtpWeek;
						}
						m4	= m4 + Integer.parseInt(selectUpdateTarget.get(i).get("w" + rtpWeek).toString());
						insParams.put("w" + psiWeek, selectUpdateTarget.get(i).get("w" + rtpWeek));
						rtpNo++;
						LOGGER.debug(i + "-" + w + ". STOCK_CODE : " + stockCode + " m4월 update주 : " + w + ". val : " + insParams.get("w" + psiWeek) + ", psiNo : " + psiNo + ", rtpNo : " + rtpNo);
					//}
					psiNo++;
				}
				insParams.put("m4", m4);
				LOGGER.debug("m4 : " + m4);
				LOGGER.debug("insParams : {}", insParams.toString());
				//scmInterfaceManagementMapper.updateSupplyPlanRtp(insParams);
			} else {
				//	Not Target
				LOGGER.debug("This Stock is not update target.");
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