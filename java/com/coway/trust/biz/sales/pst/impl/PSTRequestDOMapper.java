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
package com.coway.trust.biz.sales.pst.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.pst.PSTLogVO;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.biz.sales.pst.PSTSalesDVO;
import com.coway.trust.biz.sales.pst.PSTSalesMVO;

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
@Mapper("pstRequestDOMapper")
public interface PSTRequestDOMapper {

	/**
	 * 글을 조회한다. (상세조회)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstRequestDOInfo(Map<String, Object> params);

	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> selectPstRequestDOList(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회팝업 Stock List)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 *
	List<EgovMap> getPstRequestDOStockDetailPop(Map<String, Object> params);
	 */
	
	
	/**
	 * 글을 수정한다.
	 * 
	 * @param vo
	 *            - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	void updatePstSalesM(PSTSalesMVO pstSalesMVO);
	
	/**
	 * 글을 수정한다.
	 * 
	 * @param vo
	 *            - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	void updatePstSalesD(PSTSalesDVO pstSalesDVO);
	
	void insertPstLog(PSTLogVO pstLogVO);
	
	
	/**
	 * 글을 조회한다. (상세조회) - PST MailContact
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstRequestDOMailContact(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - PST DeliveryContact
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstRequestDODelvryContact(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - PST MailAddress
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstRequestDOMailAddress(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - PST DeliveryAddress
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstRequestDODelvryAddress(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회팝업 Stock List)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> pstRequestDOStockList(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회 combo box Person In Charge)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> cmbPstInchargeList();
	
	
	/**
	 * 글을 조회한다. (new popup - dealer combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> pstNewCmbDealerList();
	
	
	/**
	 * 글을 조회한다. (new popup - PIC combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> pstNewCmbDealerChgList(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - (new popup - dealer infomation)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstNewParticularInfo(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - (new popup - Contact)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstNewContactPop(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - (new popup - Contact)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> pstNewContactListPop(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - (add / edit address popup)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstEditAddrDetailTopPop(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (add / edit address popup)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> pstEditAddrDetailListPop(Map<String, Object> params);
	
	
	/**
	 * 글을 조회한다. (상세조회) - (add / edit address popup)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	EgovMap pstEditContDetailTopPop(Map<String, Object> params);
	
	
	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	List<EgovMap> cmbChgStockItemList(Map<String, Object> params);
	
	
	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	void insertPstSAL0062D(PSTSalesMVO pstSalesMVO);
	
	
	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	void updatePstSAL0062D(PSTSalesMVO pstSalesMVO);
	

	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	void insertPstSAL0063D(PSTSalesDVO pstSalesDVO);
	
	
	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param vo
	 *            - 조회할 정보가 담긴 VO
	 * @return 조회한 글
	 * @exception Exception
	 */
	void insertPstSAL0061D(PSTLogVO pstLogVO);
	
	int crtSeqSAL0062D();
	int crtSeqSAL0063D();
	String crtSeqSAL0061D();
	
	/**
	 * edit - add address
	 */
	int crtSeqSAL0031D();
	void insertPstSAL0031D(Map<String, Object> params);
	void updatePstSAL0031D(Map<String, Object> params);
	void updateMainPstSAL0031D(Map<String, Object> params);
	void updateSubPstSAL0031D(Map<String, Object> params);
	void delPstSAL0031D(Map<String, Object> params);
	
	/**
	 * edit - add contact
	 */
	int crtSeqSAL0032D();
	void insertPstSAL0032D(Map<String, Object> params);
//	void updatePstSAL0032D(Map<String, Object> params);
	void updateMainPstSAL0032D(Map<String, Object> params);
	void updateSubPstSAL0032D(Map<String, Object> params);
	
	
	/**
	 * RATE 구하기
	 * 
	 * @param 
	 * @return RATE
	 * @exception Exception
	 */
	EgovMap getRate();
	
	
	/**
	 * PST Type Combo Box 구하기
	 * 
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	List<EgovMap> pstTypeCmbList(Map<String, Object> params);
	
	List<EgovMap> pstNewDealerInfo(Map<String, Object> params);
	
	
	List<EgovMap> reportGrid(Map<String, Object> params);
}
