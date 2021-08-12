/**
 * 
 */
package com.coway.trust.biz.sales.pst;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.sales.pst.PSTStockListGridForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface PSTRequestDOService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> selectPstRequestDOList(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다. PST Info
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstRequestDOInfo(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  - PST MailContact
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstRequestDOMailContact(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  - PST DeliveryContact
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstRequestDODelvryContact(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  - PST MailAddress
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstRequestDOMailAddress(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  - PST DeliveryAddress
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstRequestDODelvryAddress(Map<String, Object> params);
	
	
	/**
	 * 글 목록을 조회한다.		- Stock List
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> pstRequestDOStockList(Map<String, Object> params);
	
	
	/**
	 * 글 목록을 조회한다.		- Stock List
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> cmbPstInchargeList();
	
	
	/**
	 * 글 상세조회를 한다. PST Stock List ???
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 
	List<EgovMap> getPstRequestDOStockDetailPop(Map<String, Object> params);
	 */
	
	public void updateStock(List<PSTSalesDVO> pstSalesDVOList, PSTSalesMVO pstSalesMVO);
	
	
	/**
	 * 글 목록을 조회한다.		(new popup - dealer combo box)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> pstNewCmbDealerList();
	
	
	/**
	 * 글 목록을 조회한다.		(new popup - PIC combo box)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> pstNewCmbDealerChgList(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  (new popup - dealer infomation)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstNewParticularInfo(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  (new popup - Contact)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstNewContactPop(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  (new popup - Contact)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	List<EgovMap> pstNewContactListPop(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  - (add / edit address popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstEditAddrDetailTopPop(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다.  - (add / edit address popup) x
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap pstEditContDetailTopPop(Map<String, Object> params);
	
	
	/**
	 * 글 목록을 조회한다.		- (add / edit address popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> pstEditAddrDetailListPop(Map<String, Object> params);
	
	
	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> cmbChgStockItemList(Map<String, Object> params);
	
	int crtSeqSAL0062D();
	int crtSeqSAL0063D();
	String crtSeqSAL0061D();
	
	public void insertNewReqOk(List<PSTSalesDVO> pstSalesDVOList, PSTSalesMVO pstSalesMVO);
	
	
	/**
	 * edit - add address
	 */
	int crtSeqSAL0031D();
	void insertPstSAL0031D(Map<String, Object> params);
	void updatePstSAL0031D(Map<String, Object> params);
	void updateMainPstSAL0031D(Map<String, Object> params);
	void delPstSAL0031D(Map<String, Object> params);
	
	
	/**
	 * edit - add contact
	 */
	int crtSeqSAL0032D();
	void insertPstSAL0032D(Map<String, Object> params);
//	void updatePstSAL0032D(Map<String, Object> params);
	void updateMainPstSAL0032D(Map<String, Object> params);
	
	
	/**
	 * RATE 구하기
	 * 
	 * @param 
	 * @return RATE
	 * @exception Exception
	 */
	EgovMap getRate();
	
	
	List<EgovMap> pstTypeCmbList(Map<String, Object> params);
	
	List<EgovMap> pstNewDealerInfo(Map<String, Object> params);
	
	List<EgovMap> reportGrid(Map<String, Object> params);
}
