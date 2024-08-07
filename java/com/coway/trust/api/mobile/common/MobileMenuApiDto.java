package com.coway.trust.api.mobile.common;

import com.coway.trust.api.mobile.payment.cashMatching.CashMatchingDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : MobileMenuApiDto.java
 * @Description : MobileMenuApiDto
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 1.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "MobileMenuApiDto", description = "MobileMenuApiDto")
public class MobileMenuApiDto {

	@ApiModelProperty(value = "MENU CODE")
	private String menuCode;

	@ApiModelProperty(value = "MENU NAME")
	private String menuName;

	@ApiModelProperty(value = "PGM CODE")
	private String pgmCode;

	@ApiModelProperty(value = "PGM NAME")
	private String pgmName;

	@ApiModelProperty(value = "MENU LVL")
	private int menuLvl;

	@ApiModelProperty(value = "MENU ORDER")
	private int menuOrder;

	@ApiModelProperty(value = "MENU ICON NM")
	private String menuIconNm;

	@ApiModelProperty(value = "IS_LEAF")
	private int isLeaf;

	@ApiModelProperty(value = "PAGE PATH")
	private String pagePath;

	@ApiModelProperty(value = "UPPER MENU CODE")
	private String upperMenuCode;

	public String getUpperMenuCode() {
		return upperMenuCode;
	}

	public void setUpperMenuCode(String upperMenuCode) {
		this.upperMenuCode = upperMenuCode;
	}

	public String getMenuCode() {
		return menuCode;
	}

	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public String getPgmCode() {
		return pgmCode;
	}

	public void setPgmCode(String pgmCode) {
		this.pgmCode = pgmCode;
	}

	public String getPgmName() {
		return pgmName;
	}

	public void setPgmName(String pgmName) {
		this.pgmName = pgmName;
	}

	public int getMenuLvl() {
		return menuLvl;
	}

	public void setMenuLvl(int menuLvl) {
		this.menuLvl = menuLvl;
	}

	public int getMenuOrder() {
		return menuOrder;
	}

	public void setMenuOrder(int menuOrder) {
		this.menuOrder = menuOrder;
	}

	public String getMenuIconNm() {
		return menuIconNm;
	}

	public void setMenuIconNm(String menuIconNm) {
		this.menuIconNm = menuIconNm;
	}

	public String getPagePath() {
		return pagePath;
	}

	public void setPagePath(String pagePath) {
		this.pagePath = pagePath;
	}

	public int getIsLeaf() {
		return isLeaf;
	}

	public void setIsLeaf(int isLeaf) {
		this.isLeaf = isLeaf;
	}

	public static MobileMenuApiDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, MobileMenuApiDto.class);
	}

}
