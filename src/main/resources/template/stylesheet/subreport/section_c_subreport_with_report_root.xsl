<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://ws.cmctos.com.my/ctosnet/response"
                exclude-result-prefixes="xsl r">

    <xsl:template name="section_c1_template">
 
        <xsl:variable name="seq">
            <xsl:value-of select="@seq"/>
        </xsl:variable>
        
        <p class="title">
            C1: BANKING PAYMENT HISTORY
        </p>
 
        <xsl:choose>
            <xsl:when test="../r:summary/r:enq_sum[@seq = $seq]/r:include_ccris = '1' and r:section_ccris and r:section_ccris[@data = 'true']">
                <xsl:apply-templates select="r:section_ccris" mode="sectionC1" />                    
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="../r:summary/r:enq_sum[@seq = $seq]/r:include_ccris = '0'">
                    <p class="info">Not Selected</p>
                </xsl:if>
                <xsl:if test="../r:summary/r:enq_sum[@seq = $seq]/r:include_ccris = '1' and (not(r:section_ccris) or r:section_ccris[@data = 'false'])">
                    <p class="info">No Banking Payment History Records Detected</p>
                </xsl:if>                
                <br/>
            </xsl:otherwise>
        </xsl:choose>
 
    </xsl:template>
 
    <xsl:template name="section_c2_template">
 
        <xsl:variable name="seq">
            <xsl:value-of select="@seq"/>
        </xsl:variable>
        
        <p class="title">
            C2: DISHONOURED CHEQUES (Please note that DCHEQS system is only available from 9am - 10pm)
        </p>
        <xsl:choose>
            <xsl:when test="../r:summary/r:enq_sum[@seq = $seq]/r:include_dcheq = '1' and r:section_dcheqs and r:section_dcheqs[@data = 'true']">
                <xsl:apply-templates select="r:section_dcheqs"/> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="../r:summary/r:enq_sum[@seq = $seq]/r:include_dcheq = '0' or not(../r:summary/r:enq_sum[@seq = $seq]/r:include_dcheq)">
                    <p class="info">Not Selected</p>
                </xsl:if>
                <xsl:if test="../r:summary/r:enq_sum[@seq = $seq]/r:include_dcheq = '1' and (not(r:section_dcheqs) or r:section_dcheqs[@data = 'false'])">
                    <p class="info">No Banking Payment History Records Detected</p>
                </xsl:if>
                <br/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
    <xsl:template name="section_c3_template">
 
        <p class="title">
            C3: CCRIS SUPPLEMENTARY INFORMATION
        </p>
 
        <p class="info">Will Be Available Soon</p>
 
        <br/>
 
    </xsl:template>
	
    <xsl:template match="r:section_ccris" mode="sectionC1">
 
        <xsl:apply-templates select="." mode="ccrisSumm"/>
        <br/>
 
        <xsl:apply-templates select="." mode="ccrisDetail"/>
        <br/>
 
        <xsl:apply-templates select="." mode="ccrisDerivatives"/>
        <br/>
 
    </xsl:template>	
	
    <xsl:template match="r:section_ccris" mode="ccrisSumm">
        <xsl:variable name="totalOutstanding">
            <xsl:variable name="totalVal">
                <xsl:call-template name="sumNodes">
                    <xsl:with-param name="nodes" select="r:summary/r:liabilities/r:borrower | r:summary/r:liabilities/r:guarantor"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$totalVal != 0">
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="$totalVal"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'-'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="totalLimit">
            <xsl:call-template name="addNumbersNoZero">
                <xsl:with-param name="num1" select="r:summary/r:liabilities/r:borrower/@total_limit"/>
                <xsl:with-param name="num2" select="r:summary/r:liabilities/r:guarantor/@total_limit"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="totalFec">
            <xsl:call-template name="addNumbersNoZero">
                <xsl:with-param name="num1" select="r:summary/r:liabilities/r:borrower/@fec_limit"/>
                <xsl:with-param name="num2" select="r:summary/r:liabilities/r:guarantor/@fec_limit"/>
            </xsl:call-template>
        </xsl:variable>
		
        <table class="table">
            <tr>
                <th width="40%">Subject Status</th>
                <td colspan="3">
                    <xsl:call-template name="check_empty_string">
                        <xsl:with-param name="value" select="r:summary/@entity_warning"/>
                    </xsl:call-template>
                </td>			
            </tr>
            <tr>
                <td class="title" colspan="4">CCRIS SUMMARY</td>
            </tr>
            <tr>
                <td class="header">Credit Applications</td>
                <td class="header text-center">No. of Applications</td>
                <td class="header text-center">Amount Applied</td>
                <td class="header"></td>
            </tr>
            <tr>
                <th>Approved in past 12 months</th>
                <td class="text-center">
                    <xsl:value-of select="r:summary/r:application/r:approved/@count"/>
                </td>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:application/r:approved"/>
                    </xsl:call-template>
                </td>
                <td></td>
            </tr>
            <tr>
                <th>Pending</th>
                <td class="text-center">
                    <xsl:value-of select="r:summary/r:application/r:pending/@count"/>
                </td>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:application/r:pending"/>
                    </xsl:call-template>
                </td>
                <td></td>
            </tr>
            <tr>
                <td class="header">Summary of Potential &amp; Current Liabilities</td>
                <td class="header text-center">Outstanding</td>
                <td class="header text-center">Total Limit</td>
                <td class="header text-center">FEC Limit</td>
            </tr>
            <tr>
                <th>As Borrower</th>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:liabilities/r:borrower"/>
                    </xsl:call-template>
                </td>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:liabilities/r:borrower/@total_limit"/>
                    </xsl:call-template>
                </td>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:liabilities/r:borrower/@fec_limit"/>
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>As Guarantor</th>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:liabilities/r:guarantor"/>
                    </xsl:call-template>
                </td>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:liabilities/r:guarantor/@total_limit"/>
                    </xsl:call-template>
                </td>
                <td class="text-center">
                    <xsl:call-template name="check_empty_number_no_zero">
                        <xsl:with-param name="number" select="r:summary/r:liabilities/r:guarantor/@fec_limit"/>
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>Total</th>
                <td class="text-center">
                    <xsl:value-of select="$totalOutstanding"/>
                </td>
                <td class="text-center">
                    <xsl:value-of select="$totalLimit"/>
                </td>
                <td class="text-center">
                    <xsl:value-of select="$totalFec"/>
                </td>
            </tr>
            <tr>
                <th>Legal Action Taken</th>
                <td class="text-center">
                    <xsl:call-template name="check_boolean">
                        <xsl:with-param name="input" select="r:summary/r:legal/@status"/>
                    </xsl:call-template>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <th>Special Attention Account</th>
                <td class="text-center">
                    <xsl:call-template name="check_boolean">
                        <xsl:with-param name="input" select="r:summary/r:special_attention/@status"/>
                    </xsl:call-template>
                </td>
                <td></td>
                <td></td>
            </tr>		
        </table>
    </xsl:template>
	
    <xsl:template match="r:section_ccris" mode="ccrisDerivatives">
        <table class="table">
            <tr>
                <td class="title" colspan="3">CCRIS DERIVATIVES</td>	
            </tr>
            <tr>
                <th width="25%" rowspan="2">Earliest known facility</th>
                <th width="35%">Date of application</th>
                <td width="45%">
                    <xsl:call-template name="check_empty_string">
                        <xsl:with-param name="value" select="r:derivatives/r:application/r:date"/>
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>Facility type</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:application/r:facility/@code"/> - <xsl:value-of select="r:derivatives/r:application/r:facility"/>					
                </td>
            </tr>
            <tr>
                <th rowspan="4">Secured facilities</th>
                <th># of facilities</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:facilities/r:secure/@total"/>
                </td>
            </tr>
            <tr>
                <th>Total outstanding balance (RM)</th>
                <td>
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="r:derivatives/r:facilities/r:secure/r:outstanding"/>
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>Total outstanding as % of total limit</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:facilities/r:secure/r:outstanding/@limit"/>%
                </td>
            </tr>
            <tr>
                <th>Average number of installments in arrears</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:facilities/r:secure/r:outstanding/@average"/>
                </td>
            </tr>
            <tr>
                <th rowspan="4">Unsecured facilities</th>
                <th># of facilities</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:facilities/r:unsecure/@total"/>
                </td>
            </tr>
            <tr>
                <th>Total outstanding balance (RM)</th>
                <td>
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="r:derivatives/r:facilities/r:unsecure/r:outstanding"/>
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>Total outstanding as % of total limit</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:facilities/r:unsecure/r:outstanding/@limit"/>%
                </td>
            </tr>
            <tr>
                <th>Average number of installments in arrears</th>
                <td>
                    <xsl:value-of select="r:derivatives/r:facilities/r:unsecure/r:outstanding/@average"/>
                </td>
            </tr>
        </table>	
    </xsl:template>
	
    <xsl:template match="r:section_ccris" mode="ccrisDetail">
        
        <xsl:variable name="currYear">
            <xsl:call-template name="getYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
            </xsl:call-template>
        </xsl:variable>
        
        <table class="table-ccris">
            <tr>
                <td class="title" colspan="25">CCRIS DETAILS</td>		
            </tr>
            <tr>
                <td class="header" colspan="25">Loan Information</td>		
            </tr>
            <tr>
                <th width="2%">No.</th>
                <th width="8%">Date</th>
                <th width="2%">Sts</th>
                <th width="6%">Capacity</th>
                <th width="5%">Lender Type</th>
                <th width="8%">Facility</th>
                <th width="8%">Total Outstanding Balance (RM)</th>
                <th width="8%">Date Balance Updated</th>
                <th width="8%">Limit (RM)</th>
                <th width="5%">Prin. Repmt. Term</th>
                <th width="4%">Col Type</th>
                <th width="24%" colspan="12">Conduct Of Account For Last 12 Months</th>
                <th width="5%">LGL STS</th>
                <th width="7%">Date Status Updated</th>
            </tr>
            <tr>
                <th colspan="11"></th>
                <th width="12%" colspan="6" style="text-align: left; padding-left: 1%; border-right-width: 0;">
                    <xsl:copy-of select="$currYear"/>
                </th>
                <th width="12%" colspan="6" style="text-align: right; padding-right: 1%; border-left-width: 0;">
                    <xsl:copy-of select="$currYear - 1"/>
                </th>
                <th></th>
                <th></th>
            </tr>
            <tr>
                <th colspan="11">Outstanding Credit</th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">0</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">1</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">2</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">3</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">4</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">5</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">6</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">7</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">8</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">9</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">10</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th width="2%">
                    <xsl:call-template name="getPastMonthFirstLetter">
                        <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                        <xsl:with-param name="past">11</xsl:with-param>
                    </xsl:call-template>
                </th>
                <th></th>
                <th></th>
            </tr>
            <xsl:apply-templates mode="loanDetails" select="r:accounts"/>
            <tr>
                <td class="header" colspan="25">Special Attention Account</td>		
            </tr>
            <xsl:apply-templates mode="specialDetails" select="r:special_attention_accs"/>
            <tr>
                <td class="header" colspan="25">Credit Application</td>		
            </tr>
            <xsl:apply-templates mode="apps" select="r:applications"/>
        </table>
        <br/>
        <xsl:apply-templates mode="remarkLegend" select="."/>
    </xsl:template>
	
    <xsl:template match="r:applications" mode="apps">
        
        <xsl:if test="r:application">
            <xsl:for-each select = "r:application" >
                <tr>
                    <td>
                        <xsl:value-of select="position()"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:date"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:status/@code"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:capacity/@code"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:lender_type/@code"/>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:call-template name="check_empty_number">
                            <xsl:with-param name="number" select="r:amount"/>
                        </xsl:call-template>
                    </td>
                    <td colspan="16"></td>
                </tr>
            </xsl:for-each>
        </xsl:if>
        
        <xsl:if test="not(r:application)">
            <xsl:call-template name="ccris_details_blank"/>
        </xsl:if>
        	
    </xsl:template>
	
    <xsl:template match="r:special_attention_accs" mode="specialDetails">
        
        <xsl:if test="r:special_attention_acc">
            <xsl:for-each select = "r:special_attention_acc" >
                <tr>
                    <td>
                        <xsl:value-of select="position()"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:approval_date"/>
                    </td>
                    <td></td>
                    <td>
                        <xsl:value-of select="r:capacity/@code"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:lender_type/@code"/>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:call-template name="check_empty_number">
                            <xsl:with-param name="number" select="r:limit"/>
                        </xsl:call-template>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:value-of select="r:legal/@status"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:legal/r:date"/>
                    </td>
                </tr>
                <xsl:apply-templates mode="specialSubs" select="r:sub_accounts"/>		
            </xsl:for-each>
        </xsl:if>
        
        <xsl:if test="not(r:special_attention_acc)">
            <xsl:call-template name="ccris_details_blank"/>
        </xsl:if>	
        	
    </xsl:template>
    	
    <xsl:template match="r:sub_accounts" mode="specialSubs">
        <xsl:for-each select = "r:sub_account" >
            <tr>
                <td></td>
                <td></td>
                <td>
                    <xsl:value-of select="r:cr_positions/r:cr_position[1]/r:status/@code"/>
                </td>
                <td></td>
                <td></td>
                <td>
                    <xsl:value-of select="r:facility/@code"/>
                </td>
                <td>
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="r:cr_positions/r:cr_position[1]/r:balance"/>
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:value-of select="r:cr_positions/r:cr_position[1]/r:position_date"/>
                </td>
                <td></td>
                <td>
                    <xsl:value-of select="r:repay_term/@code"/>
                </td>
                <td></td>	
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </xsl:for-each>	
    </xsl:template>
	
    <xsl:template match="r:accounts" mode="loanDetails">
        <xsl:if test="r:account">
            <xsl:variable name="totalLimit">
                <xsl:call-template name="sumNodes">
                    <xsl:with-param name="nodes" select="r:account/r:limit"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="totalBalance">
                <xsl:call-template name="sumNodes">
                    <xsl:with-param name="nodes" select="r:account/r:sub_accounts/r:sub_account/r:cr_positions/r:cr_position/r:balance"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:for-each select = "r:account">
                <tr>
                    <xsl:choose>
                        <xsl:when test="r:org1 = '7401' or r:org1 = 'PT'">
                            <td bgcolor="rgb(78,197,115)">
                                <xsl:value-of select="position()"/>
                            </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td>
                                <xsl:value-of select="position()"/>
                            </td>
                        </xsl:otherwise>
                    </xsl:choose>
                    <td>
                        <xsl:value-of select="r:approval_date"/>
                    </td>
                    <td></td>
                    <td>
                        <xsl:value-of select="r:capacity/@code"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:lender_type/@code"/>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:call-template name="check_empty_number_no_zero">
                            <xsl:with-param name="number" select="r:limit"/>
                        </xsl:call-template>
                    </td>
                    <td></td>
                    <td>
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:collaterals/r:collateral[1]/@code"/>
                        </xsl:call-template>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:value-of select="r:legal/@status"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:legal/r:date"/>
                    </td>
                </tr>
                <xsl:apply-templates mode="colls" select="r:collaterals"/>
                <xsl:apply-templates mode="loanSubs" select="r:sub_accounts"/>		
            </xsl:for-each>
            
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>&#160;</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>Total Outstanding Balance:</td>
                <td>
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="$totalBalance"/>
                    </xsl:call-template>
                </td>
                <td>Total Limit:</td>
                <td>
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="$totalLimit"/>
                    </xsl:call-template>
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>	
            </tr>
        </xsl:if>
    </xsl:template>		
    <xsl:template match="r:sub_accounts" mode="loanSubs">
        <xsl:for-each select = "r:sub_account" >
            <tr>
                <td></td>
                <td></td>
                <td>
                    <xsl:value-of select="r:cr_positions/r:cr_position[1]/r:status/@code"/>
                </td>
                <td></td>
                <td></td>
                <td>
                    <xsl:value-of select="r:facility/@code"/>
                </td>
                <td>
                    <xsl:call-template name="check_empty_number">
                        <xsl:with-param name="number" select="r:cr_positions/r:cr_position[1]/r:balance"/>
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:value-of select="r:cr_positions/r:cr_position[1]/r:position_date"/>
                </td>
                <td></td>
                <td>
                    <xsl:value-of select="r:repay_term/@code"/>
                </td>
                <td>
                    <xsl:call-template name="check_empty_string">
                        <xsl:with-param name="value" select="r:collaterals/r:collateral[1]/@code"/>
                    </xsl:call-template>
                </td>			
                <xsl:apply-templates mode="inst_arrears" select="r:cr_positions"/>
                <td></td>
                <td></td>
            </tr>
            <xsl:apply-templates mode="colls" select="r:collaterals"/>
        </xsl:for-each>	
    </xsl:template>
	
    <xsl:template match="r:collaterals" mode="colls">
        <xsl:for-each select = "r:collateral[position() &gt; 1]" >
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>
                    <xsl:value-of select="@code"/>
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
	
    <xsl:template match="r:cr_positions" mode="inst_arrears">
        <xsl:variable name="mth1">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">0</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth2">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">1</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth3">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">2</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth4">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">3</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth5">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">4</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth6">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">5</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth7">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">6</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth8">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">7</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth9">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">8</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth10">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">9</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth11">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">10</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mth12">
            <xsl:call-template name="getPastMonthAndYearOnly">
                <xsl:with-param name="datestr" select="/r:report/r:enq_report/r:header/r:enq_date"/>
                <xsl:with-param name="past">11</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
		
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth1]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth2]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth3]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth4]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth5]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth6]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth7]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth8]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth9]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth10]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth11]/r:inst_arrears"/>
        </td>
        <td>
            <xsl:value-of select="r:cr_position[substring(r:position_date,4,7) = $mth12]/r:inst_arrears"/>
        </td>
    </xsl:template>

	<xsl:key name="facility_codes" match="r:accounts/r:account/r:sub_accounts/r:sub_account/r:facility | r:special_attention_accs/r:special_attention_acc/r:sub_accounts/r:sub_account/r:facility" use="@code"/>
	<xsl:key name="codes" match="r:accounts/r:account/r:sub_accounts/r:sub_account/r:cr_positions/r:cr_position/r:status | r:special_attention_accs/r:special_attention_acc/r:sub_accounts/r:sub_account/r:cr_positions/r:cr_position/r:status" use="@code"/>
	<xsl:key name="application_codes" match="r:applications/r:application/r:status" use="@code"/>
	<xsl:key name="legal_status" match="r:accounts/r:account/r:legal | r:special_attention_accs/r:special_attention_acc/r:legal" use="@status"/>
	
    <xsl:template match="r:section_ccris" mode="remarkLegend">		
        <div>
            <b>
                <u>
                    REMARK LEGEND
                </u>
            </b>
            <br/>
            <b>
                FACILITY:
            </b>
            <br/>
            <!--            <xsl:apply-templates select="r:accounts/r:account/r:sub_accounts 
            | r:special_attention_accs/r:special_attention_acc/r:sub_accounts" mode="groupFacStat"/>-->
            
            <xsl:variable name="ptptnLoan">
                <xsl:for-each select="r:accounts/r:account">
                    <xsl:choose>
                        <xsl:when test="r:org1 = '7401' or r:org1 = 'PT'">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:for-each select="r:accounts/r:account/r:sub_accounts | r:special_attention_accs/r:special_attention_acc/r:sub_accounts">
				
                <xsl:for-each select="r:sub_account/r:facility[generate-id() = generate-id(key('facility_codes',@code)[1])]">
                
                    <xsl:value-of select="@code"/> – <xsl:value-of select="."/>
              
                    <br/>
                      
                </xsl:for-each>
                
            </xsl:for-each>
            <xsl:if test="contains($ptptnLoan, '1')">
                Student Loan Identified
                <br/>
            </xsl:if>
            
            <br/>
            <b>
                LOAN INFOMATION STATUS:
            </b>
            <br/>
            <!--            <xsl:apply-templates select="r:accounts/r:account/r:sub_accounts 
            | r:special_attention_accs/r:special_attention_acc/r:sub_accounts" mode="groupLoanStat"/>-->
            
            
            <xsl:for-each select="r:accounts/r:account/r:sub_accounts | r:special_attention_accs/r:special_attention_acc/r:sub_accounts">
                
                <xsl:for-each select="r:sub_account/r:cr_positions/r:cr_position/r:status[generate-id() = generate-id(key('codes',@code)[1])]">
                
                    <xsl:value-of select="@code"/> – <xsl:value-of select="."/>
              
                    <br/>
                      
                </xsl:for-each>
                
            </xsl:for-each>            
            
            <br/>            
            
            <b>
                CREDIT APPLICATION STATUS:
            </b>
            <br/>
            

            
            <xsl:for-each select="r:applications">
                
                <xsl:for-each select="r:application/r:status[generate-id() = generate-id(key('application_codes',@code)[1])]">
                
                    <xsl:value-of select="@code"/> – <xsl:value-of select="."/>
                    <br/>
                
                </xsl:for-each>
                
            </xsl:for-each>
            
            <br/>            
            
            <b>
                LEGAL STATUS:
            </b>
            <br/>
            
            <xsl:for-each select="r:accounts | r:special_attention_accs">
            
                <xsl:for-each select="r:account/r:legal[generate-id() = generate-id(key('legal_status',@status)[1])] | r:special_attention_acc/r:legal[generate-id() = generate-id(key('legal_status',@status)[1])]">
                    
                    <xsl:value-of select="@status"/> – <xsl:value-of select="r:name"/>
                    <br/>
                    
                </xsl:for-each>
            
            </xsl:for-each>
            
        </div>
    </xsl:template>

    <!--    <xsl:template match="r:sub_accounts" mode="groupLoanStat">
        <xsl:key name="loanStatus" match="r:sub_account/r:cr_positions/r:cr_position" use="r:status/@code"/>
        <xsl:apply-templates mode="outputLoanStatus" select="r:sub_account/r:cr_positions/r:cr_position[
                        generate-id() = generate-id(key('loanStatus', r:status/@code)[1])]"/>
    </xsl:template>
    <xsl:template match="r:cr_position" mode="outputLoanStatus">
        <xsl:value-of select="r:status/@code"/> – <xsl:value-of select="r:status"/>
        <br/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>-->
	
    <!--    <xsl:template match="r:sub_accounts" mode="groupFacStat">
        <xsl:key name="facStatus" match="r:sub_account" use="r:facility/@code"/>
        <xsl:apply-templates mode="outputFacStatus" select="r:sub_account[
                        generate-id() = generate-id(key('facStatus', r:facility/@code)[1])]"/>
    </xsl:template>
    <xsl:template match="r:sub_account" mode="outputFacStatus">
        <xsl:value-of select="r:facility/@code"/> – <xsl:value-of select="r:facility"/>
        <br/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>-->
	
    <xsl:template name="sumNodes">
        <xsl:param name="index" select="1"/>
        <xsl:param name="nodes"/>
        <xsl:param name="total" select="0"/>
        <xsl:variable name="currentValue">
            <xsl:choose>
                <xsl:when test="$nodes[$index][text() != '']">
                    <xsl:variable name = "chkNumber" select = "translate($nodes[$index], ',', '')"/>
                    <xsl:choose>
                        <xsl:when test="number($chkNumber) = $chkNumber and starts-with($chkNumber, '-') = false">
                            <xsl:value-of select="$chkNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$index=count($nodes)">
                <xsl:value-of select="$total + $currentValue"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="sumNodes">
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="total" select="$total + $currentValue"/>
                    <xsl:with-param name="nodes" select="$nodes"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template name="check_boolean">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="$input = 1">
                <xsl:value-of select="'Y'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'N'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template name="addNumbersNoZero">
        <xsl:param name="num1"/>
        <xsl:param name="num2"/>
        <xsl:variable name="value1">
            <xsl:choose>
                <xsl:when test="string-length($num1) &gt; 0">
                    <xsl:variable name = "chkNumber" select = "translate($num1, ',', '')"/>
                    <xsl:choose>
                        <xsl:when test="number($chkNumber) = $chkNumber">
                            <xsl:value-of select="$chkNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="value2">
            <xsl:choose>
                <xsl:when test="string-length($num2) &gt; 0">
                    <xsl:variable name = "chkNumber" select = "translate($num2, ',', '')"/>
                    <xsl:choose>
                        <xsl:when test="number($chkNumber) = $chkNumber">
                            <xsl:value-of select="$chkNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="($value1 + $value2) != 0">
                <xsl:value-of select="format-number($value1 + $value2,'##,##0.00')"/>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'-'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template name="getPastMonthFirstLetter">
        <xsl:param name="datestr"/>
        <xsl:param name="past"/>		
        <xsl:variable name="currMth">
            <xsl:value-of select="substring($datestr,6,2)"/>
        </xsl:variable>		
        <xsl:variable name="month">
            <xsl:choose> 
                <xsl:when test="($currMth - $past) &lt;= 0">
                    <xsl:value-of select="$currMth - $past + 12"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currMth - $past"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>		
        <xsl:if test="$month = 1">
            <xsl:text>J</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 2">
            <xsl:text>F</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 3">
            <xsl:text>M</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 4">
            <xsl:text>A</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 5">
            <xsl:text>M</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 6">
            <xsl:text>J</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 7">
            <xsl:text>J</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 8">
            <xsl:text>A</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 9">
            <xsl:text>S</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 10">
            <xsl:text>O</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 11">
            <xsl:text>N</xsl:text>
        </xsl:if>
        <xsl:if test="$month = 12">
            <xsl:text>D</xsl:text>
        </xsl:if>
    </xsl:template>
	
    <xsl:template name="getYearOnly">
        <xsl:param name="datestr"/>
        <xsl:variable name="yyyy">
            <xsl:value-of select="substring($datestr,1,4)"/>
        </xsl:variable>
        <xsl:value-of select="$yyyy"/>
    </xsl:template>
	
    <xsl:template name="getPastMonthAndYearOnly">
        <xsl:param name="datestr"/>
        <xsl:param name="past"/>
        <xsl:variable name="mth">
            <xsl:value-of select="substring($datestr,6,2)"/>
        </xsl:variable>
        <xsl:variable name="yyyy">
            <xsl:value-of select="substring($datestr,1,4)"/>
        </xsl:variable>
        <xsl:variable name="mthyyyy">
            <xsl:choose> 
                <xsl:when test="($mth - $past) &lt;= 0">
                    <xsl:value-of select="concat(format-number($mth - $past + 12,'00'),'-',$yyyy - 1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(format-number($mth - $past,'00'),'-',$yyyy)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$mthyyyy"/>		
    </xsl:template>
    
    <!-- start ccris_details_blank -->
    <xsl:template name="ccris_details_blank">
        <tr>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
            <td>&#160;</td>
        </tr>
    </xsl:template>
    <!-- finish ccris_details_blank -->
 
    <xsl:template match="r:section_dcheqs">
 
        <p class="header">
            DISHONOURED CHEQUE INFORMATION (OWN BANK)
        </p>
 
        <table class="table">
            <tr>
                <th width="15%">Account No.</th>
                <th width="15%">Issuance Date</th>
                <th width="15%">Cheque No.</th>
                <th width="20%">Amount</th>
                <th width="35%">Remark</th>
            </tr>
            <xsl:for-each select="r:dcheque_owns/r:dcheque_own" >
                <tr>
                    <td>
                        <xsl:value-of select="r:account_no"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:issue_date"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:cheque_no"/>
                    </td>
                    <td>
                        <xsl:call-template name="check_empty_number">
                            <xsl:with-param name="number" select="r:amount"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:value-of select="r:remarks"/>
                    </td>				
                </tr>				
            </xsl:for-each>						
        </table>
        <br/>
 
        <p class="header">
            DISHONOURED CHEQUE INFORMATION (COMMERCIAL BANK)
        </p>
 
        <table class="table">
            <tr>
                <th width="20%">Bank</th>
                <th width="20%">Account No.</th>
                <th width="20%">Issuance Date</th>	
                <th width="40%">Remark</th>
            </tr>
            <xsl:for-each select="r:dcheques/r:dcheque" >
                <tr>		
                    <td>
                        <xsl:value-of select="r:bank_no"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:account_no"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:issue_date"/>
                    </td>
                    <td>
                        <xsl:value-of select="r:remarks"/>
                    </td>
                </tr>
            </xsl:for-each>						
        </table>
        <br/>
    </xsl:template>
 
</xsl:stylesheet>