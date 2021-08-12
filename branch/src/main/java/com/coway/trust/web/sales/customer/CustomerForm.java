package com.coway.trust.web.sales.customer;

import com.coway.trust.biz.sales.customer.CustomerBVO;
import com.coway.trust.biz.sales.customer.CustomerCVO;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.cmmn.model.GridDataSet;

public class CustomerForm {
	private GridDataSet<CustomerCardListGridForm> dataSet;				// Credit Card Form
	private GridDataSet<CustomerBankAccListGridForm> dataSetBank;	// Bank Account Form
	private CustomerCVO customerCVO;			// Credit Card VO
	private CustomerBVO customerBVO;			// Bank Account VO
	private CustomerVO customerVO;				// Customer Basic Info VO
	
	public GridDataSet<CustomerCardListGridForm> getDataSet() {
		return dataSet;
	}
	public void setDataSet(GridDataSet<CustomerCardListGridForm> dataSet) {
		this.dataSet = dataSet;
	}
	public CustomerCVO getCustomerCVO() {
		return customerCVO;
	}
	public void setCustomerCVO(CustomerCVO customerCVO) {
		this.customerCVO = customerCVO;
	}
	public CustomerVO getCustomerVO() {
		return customerVO;
	}
	public void setCustomerVO(CustomerVO customerVO) {
		this.customerVO = customerVO;
	}
	public GridDataSet<CustomerBankAccListGridForm> getDataSetBank() {
		return dataSetBank;
	}
	public void setDataSetBank(GridDataSet<CustomerBankAccListGridForm> dataSetBank) {
		this.dataSetBank = dataSetBank;
	}
	public CustomerBVO getCustomerBVO() {
		return customerBVO;
	}
	public void setCustomerBVO(CustomerBVO customerBVO) {
		this.customerBVO = customerBVO;
	}
	
	
}
