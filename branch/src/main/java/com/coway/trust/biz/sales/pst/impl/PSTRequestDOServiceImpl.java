/**
 * 
 */
package com.coway.trust.biz.sales.pst.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.pst.PSTLogVO;
import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.biz.sales.pst.PSTSalesDVO;
import com.coway.trust.biz.sales.pst.PSTSalesMVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("pstRequestDOService")
public class PSTRequestDOServiceImpl extends EgovAbstractServiceImpl implements PSTRequestDOService {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "pstRequestDOMapper")
	private PSTRequestDOMapper pstRequestDOMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectPstRequestDOList(Map<String, Object> params) {
		
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.selectPstRequestDOList(params);
	}
	
	
	/**
	 * 상세 조회한다. - PST MailContact
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstRequestDOMailContact(Map<String, Object> params) {
		
		logger.debug("getPstRequestDODetaiPop serviceImpl 호출 : MailContact");
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.pstRequestDOMailContact(params);
	}
	
	
	/**
	 * 상세 조회한다. - PST DeliveryContact
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstRequestDODelvryContact(Map<String, Object> params) {
		
		logger.debug("getPstRequestDODetaiPop serviceImpl 호출 : DelvryContact");
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.pstRequestDODelvryContact(params);
	}
	
	
	/**
	 * 상세 조회한다. - PST MailContact
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstRequestDOMailAddress(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstRequestDOMailAddress(params);
	}
	
	
	/**
	 * 상세 조회한다. - PST DeliveryContact
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstRequestDODelvryAddress(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstRequestDODelvryAddress(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstRequestDOInfo(Map<String, Object> params) {
		
		logger.debug("getPstRequestDODetaiPop serviceImpl Info호출 : ");
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.pstRequestDOInfo(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> pstRequestDOStockList(Map<String, Object> params) {
		
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.pstRequestDOStockList(params);
	}
	
	
	/**
	 * 글 목록을 조회한다. combo box Person In Charge
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> cmbPstInchargeList() {
		
		return pstRequestDOMapper.cmbPstInchargeList();
	}
	
	
	/**
	 * 글 목록을 조회한다. ??
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 
	public List<EgovMap> getPstRequestDOStockDetailPop(Map<String, Object> params) {
		
		logger.debug("getPstRequestDODetaiPop serviceImpl 호출 : " + params.get("pstSalesOrdId"));
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.getPstRequestDOStockDetailPop(params);
	}
	*/
	
	
	/**
	 * 글 목록을 조회한다. (new popup - dealer combo box)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> pstNewCmbDealerList() {
		
		return pstRequestDOMapper.pstNewCmbDealerList();
	}
	
	
	/**
	 * 글 목록을 조회한다. (new popup - PIC combo box)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> pstNewCmbDealerChgList(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstNewCmbDealerChgList(params);
	}
	
	
	/**
	 * 상세조회. (new popup - dealer infomation)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstNewParticularInfo(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstNewParticularInfo(params);
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
	public void updateStock(List<PSTSalesDVO> pstSalesDVOList, PSTSalesMVO pstSalesMVO) {
		
		PSTLogVO pstLogVO = null;
		
		BigDecimal totalAmt = CalcItemsAmountTotal(pstSalesDVOList);
		
		logger.debug("##### totalAmt :"+totalAmt);
		
		int totalBal = 0;
		int statusID = 0;
		
//		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
//		params.put("userId", sessionVO.getUserId());
		
		for(PSTSalesDVO pstSalesDVO : pstSalesDVOList) {
			
			int newPstItmCanQty = pstSalesDVO.getPstItmCanQty2(); //Quantity to cancel		
			int newPstItmBalQty = pstSalesDVO.getPstItmBalQty() - newPstItmCanQty; //(Balance Quantity) - (Quantity to cancel)
			
			totalBal += newPstItmBalQty;
			
			pstSalesDVO.setPstItmBalQty(newPstItmBalQty);
			pstSalesDVO.setPstItmCanQty(pstSalesDVO.getPstItmCanQty() + newPstItmCanQty);
			pstSalesDVO.setPstItmTotPrc(BigDecimal.valueOf(newPstItmBalQty).multiply(pstSalesDVO.getPstItmPrc()));
			
			pstRequestDOMapper.updatePstSalesD(pstSalesDVO);

			if(newPstItmCanQty > 0) {
    			pstLogVO = new PSTLogVO();
    			
    			pstLogVO.setPstSalesOrdId(pstSalesDVO.getPstSalesOrdId());
    			pstLogVO.setPstStockId(pstSalesDVO.getPstItmStkId());
    			pstLogVO.setPstStockRem(pstSalesDVO.getPstStockRem());
    			pstLogVO.setPstQty(newPstItmCanQty); //입력받은 취소수량
    			pstLogVO.setPstTypeId(SalesConstants.SALES_PSTCAN_CODEID);
    			pstLogVO.setPstRefNo(pstSalesMVO.getPstRefNo());
    			pstLogVO.setCrtUserId(pstSalesDVO.getCrtUserId());
    			
    			pstRequestDOMapper.insertPstLog(pstLogVO);
			}
		}
		
		statusID = totalBal == 0 ? 4 : 1;

		pstSalesMVO.setPstStusId(statusID);
		pstSalesMVO.setPstTotAmt(totalAmt);
		
		pstRequestDOMapper.updatePstSalesM(pstSalesMVO);
	}
	
    private BigDecimal CalcItemsAmountTotal(List<PSTSalesDVO> pstSalesDVOList)
    {
    	BigDecimal totalAmt = BigDecimal.ZERO;

        if(pstSalesDVOList.size() > 0) {
            
        	int canQty = 0;
            
        	for(PSTSalesDVO pstSalesDVO : pstSalesDVOList) {

        		canQty = pstSalesDVO.getPstItmCanQty2();

                //totalAmt += ((int.Parse(det.GetDataKeyValue("PSTItemBalQty").ToString()) - int.Parse(CanQty.ToString())) * double.Parse(ItemPrice.Value.ToString()));
                totalAmt = totalAmt.add(BigDecimal.valueOf(pstSalesDVO.getPstItmBalQty() - canQty).multiply(pstSalesDVO.getPstItmPrc()));
            }

        }

        return totalAmt;
    }
    
    
    /**
	 * 글 목록을 조회한다. (contact popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstNewContactPop(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstNewContactPop(params);
	}
	
	
    /**
	 * 글 목록을 조회한다. (add / edit address popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstEditAddrDetailTopPop(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstEditAddrDetailTopPop(params);
	}
	
	
	/**
	 * 글 목록을 조회한다. (add / edit address popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> pstEditAddrDetailListPop(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstEditAddrDetailListPop(params);
	}
	
	
	/**
	 * 글 목록을 조회한다. (add / edit address popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> pstNewContactListPop(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstNewContactListPop(params);
	}
	
	
	/**
	 * 글 목록을 조회한다. (add / edit address popup)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap pstEditContDetailTopPop(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstEditContDetailTopPop(params);
	}
	
	
	/**
	 * item을 조회한다. (New popup - ADD STOCK ITEM : Stock Item combo box)
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> cmbChgStockItemList(Map<String, Object> params) {
		
		return pstRequestDOMapper.cmbChgStockItemList(params);
	}
	
	
	/**
	 * SEQ가져오기
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public int crtSeqSAL0062D() {
		
		return pstRequestDOMapper.crtSeqSAL0062D();
	}
	
	public int crtSeqSAL0063D() {
		
		return pstRequestDOMapper.crtSeqSAL0063D();
	}

    public String crtSeqSAL0061D() {
    	
    	return pstRequestDOMapper.crtSeqSAL0061D();
    }
    
    
    /**
	 * 글을 등록한다.
	 * 
	 * @param vo
	 *            - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void insertNewReqOk(List<PSTSalesDVO> pstSalesDVOList, PSTSalesMVO pstSalesMVO) {
		
		PSTLogVO pstLogVO = null;
		
		pstRequestDOMapper.insertPstSAL0062D(pstSalesMVO);		// PST Sales Master
		
		for(PSTSalesDVO pstSalesDVO : pstSalesDVOList) {
			
			pstRequestDOMapper.insertPstSAL0063D(pstSalesDVO);	// PST Sales Detail

			pstLogVO = new PSTLogVO();
			
			pstLogVO.setPstTrnsitId(pstRequestDOMapper.crtSeqSAL0061D());
			pstLogVO.setPstSalesOrdId(pstSalesMVO.getPstSalesOrdId());
			pstLogVO.setPstStockId(pstSalesDVO.getPstItmStkId());
			pstLogVO.setPstStockRem(pstSalesDVO.getPstStockRem());
			pstLogVO.setPstQty(pstSalesDVO.getPstItmReqQty()); //입력받은 취소수량
			pstLogVO.setPstTypeId(pstSalesMVO.getPstCurTypeId());
			pstLogVO.setPstRefNo(pstSalesMVO.getPstRefNo());
			pstLogVO.setCrtUserId(pstSalesDVO.getCrtUserId());
			
			pstRequestDOMapper.insertPstSAL0061D(pstLogVO);		// PST Sales Log
		}
		
	}
	
	
	public int crtSeqSAL0031D() {
    	
    	return pstRequestDOMapper.crtSeqSAL0031D();
    }
	
	
	/**
	 * edit - add address
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertPstSAL0031D(Map<String, Object> params) {
		pstRequestDOMapper.insertPstSAL0031D(params);
	}
	
	
	/**
	 * edit - add address
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updatePstSAL0031D(Map<String, Object> params) {
		pstRequestDOMapper.updatePstSAL0031D(params);
	}
	
	
	/**
	 * edit - add address
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void delPstSAL0031D(Map<String, Object> params) {
		pstRequestDOMapper.delPstSAL0031D(params);
	}
	
	
	/**
	 * edit - add address
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updateMainPstSAL0031D(Map<String, Object> params) {
		pstRequestDOMapper.updateSubPstSAL0031D(params);
		pstRequestDOMapper.updateMainPstSAL0031D(params);
		
	}
	
	
	public int crtSeqSAL0032D() {
    	
    	return pstRequestDOMapper.crtSeqSAL0032D();
    }
	
	
	/**
	 * edit - add contact
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertPstSAL0032D(Map<String, Object> params) {
		pstRequestDOMapper.insertPstSAL0032D(params);
	}
	
	
	/**
	 * edit - add address
	 * 
	 * @param 
	 * @return void
	 * @exception contact
	 */
	@Override
	public void updateMainPstSAL0032D(Map<String, Object> params) {
		pstRequestDOMapper.updateSubPstSAL0032D(params);
		pstRequestDOMapper.updateMainPstSAL0032D(params);
		
	}
	
	
	/**
	 * RATE 구하기
	 * 
	 * @param 
	 * @return RATE
	 * @exception Exception
	 */
	public EgovMap getRate() {
		
		return pstRequestDOMapper.getRate();
	}
	
	
	@Override
	public List<EgovMap> pstTypeCmbList(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstTypeCmbList(params);
	}
	
	@Override
	public List<EgovMap> pstNewDealerInfo(Map<String, Object> params) {
		
		return pstRequestDOMapper.pstNewDealerInfo(params);
	}
	
	@Override
	public List<EgovMap> reportGrid(Map<String, Object> params){
		return pstRequestDOMapper.reportGrid(params);
	}
    
}
