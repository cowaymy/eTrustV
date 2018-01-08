<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://ws.cmctos.com.my/ctosnet/response"
                exclude-result-prefixes="xsl r">

    <xsl:template name="trade_reference_template">
        
        <xsl:if test="@type = 'TR'">
            
            <p style="page-break-before: always;"/>
            
            <xsl:if test="@title != ''">
                <p class="title">
                    TRADE REFERENCE
                </p>
            </xsl:if>
            
            <xsl:call-template name="trade_reference_header_template"/>
            <xsl:call-template name="trade_reference_relationship_template"/>
            <xsl:call-template name="trade_reference_sponsor_template"/>
            <xsl:call-template name="trade_reference_account_status_template"/>
            <xsl:call-template name="trade_reference_return_cheque_template"/>
            <xsl:call-template name="trade_reference_legal_action_template"/>
            <xsl:call-template name="trade_reference_contact_template"/>
            <xsl:call-template name="trade_reference_settlement_template"/>
            
            <p class="info-no-style text-center">
                <b>- End of Report -</b>
            </p>
            <br/>
        
        </xsl:if>

    </xsl:template>

    <!-- start trade_reference_header -->
    <xsl:template name="trade_reference_header_template">
        
        <xsl:if test="r:header">
            
            <xsl:for-each select="r:header">
            
                <table class="table">
                    <tr>
                        <th class="caption">Date</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:date"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">Trade Reference No.</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:report_no"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption" rowspan="3">To</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:req_name"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:req_com_name"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:req_com_addr"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">From</th>
                        <td class="long-content" colspan="3"> 
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:ref_com_name"/>
                            </xsl:call-template>
                        </td>
                    </tr>                    
                </table>
            
                <p class="notice">Note: This notation pertains to the information that you may receive below:</p>
            
                <p class="notice">References: These are trade references which you or your company have requested from other businesses on your subject of enquiry.<br/>
                    <br/>
                    It is based on actual trade experiences of the trade referee with your subject of enquiry or a company or business to which your subject of enquiry is connected to. It is provided by the trade referees directly to
                    you. Should you have any questions relating to the information herein please refer to the trade referee or the subject for further clarification.<br/>
                    <br/>
                    As with any other trade reference which you may receive, whether positive or negative, do exercise the normal caution, judgment and discretion for such references.</p>
            
                <br/>
            
                <p class="header">
                    Subject of Reference :
                    <xsl:value-of select="r:name"/>
                    <xsl:if test="r:nic_brno != '' and r:ic_lcno != ''">
                        (<xsl:value-of select="r:nic_brno"/> / <xsl:value-of select="r:ic_lcno"/>)
                    </xsl:if>
                    <xsl:if test="r:nic_brno != '' and r:ic_lcno = ''">
                        (<xsl:value-of select="r:nic_brno"/>)
                    </xsl:if>
                    <xsl:if test="r:nic_brno = '' and r:ic_lcno != ''">
                        (<xsl:value-of select="r:ic_lcno"/>)
                    </xsl:if>
                </p>
            
                <p class="notice">Your request of <xsl:value-of select="r:date"/> for a reference refers. This reference in given to you in strict confidence and meant only for your use. You shall not circulate, inform or disseminate it to any other party including the subjects concerned unless we indicate otherwise. You use these information at your own risk and we are not liable for any loss or damage, if any that may arise.</p>
            
            </xsl:for-each>
            
            <br/>
            
        </xsl:if>                
        
    </xsl:template>
    <!-- finish trade_reference_header -->

    <!-- start trade_reference_relationship -->
    <xsl:template name="trade_reference_relationship_template">
        
        <xsl:if test="r:enquiry/r:section[@id = 'relationship']">
            
            <xsl:for-each select="r:enquiry/r:section[@id = 'relationship']">
            
                <p class="header">The following information are in relation to Account No: <xsl:value-of select="r:data[@name = 'account_no']"/></p>
        
                <table class="table">
                    <tr>
                        <td class="header caption text-left">1. Relationship</td>
                        <td class="short-content">
                            Subject is <xsl:value-of select="r:data[@name = 'rel_type']"/>
                        </td>
                        
                        <td class="header caption text-left">Start Date</td>
                        <td class="short-content">
                            <xsl:if test="r:data[@name = 'rel_sday'] != '' and r:data[@name = 'rel_smonth'] != '' and r:data[@name = 'rel_syear'] != ''">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'rel_sday']"/>
                                </xsl:call-template>
                                &#160;
                                <xsl:call-template name="month_name_template">
                                    <xsl:with-param name="month" select="r:data[@name = 'rel_smonth']"/>
                                </xsl:call-template>
                                &#160;
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'rel_syear']"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'rel_sday'] = '' and r:data[@name = 'rel_smonth'] = '' and r:data[@name = 'rel_syear'] = ''">
                                Not Provided
                            </xsl:if>
                        </td>
                    </tr>
                </table>

            </xsl:for-each>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish trade_reference_relationship -->

    <!-- start trade_reference_sponsor -->
    <xsl:template name="trade_reference_sponsor_template">
        
        <xsl:if test="r:enquiry/r:section[@id = 'sponsor']/r:record">
            
            <p class="notice">To the best of our knowledge, we have the following info:</p>
            
            <table class="table">
                <tr>
                    <th class="caption" width="20px">No.</th>
                    <th class="caption">Name</th>
                    <th class="caption">New ID / ID No.</th>
                    <th class="caption">Type</th>
                    <th class="caption">Source</th>
                    <th class="caption">Date</th>
                </tr>
                
                <xsl:for-each select="r:enquiry/r:section[@id = 'sponsor']/r:record">
                    <tr>
                        <td width="20px">
                            <xsl:value-of select="@seq"/>.
                        </td>
                        <td>
                            <xsl:value-of select="r:data[@name = 'name']"/>
                        </td>
                        <td>
                            <xsl:if test="r:data[@name = 'nic_brno'] != '' and r:data[@name = 'ic_lcno'] = ''">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'nic_brno']"/>
                                </xsl:call-template>

                            </xsl:if>
                            <xsl:if test="r:data[@name = 'nic_brno'] = '' and r:data[@name = 'ic_lcno'] != ''">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'ic_lcno']"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'nic_brno'] != '' and r:data[@name = 'ic_lcno'] != ''">
                                <xsl:value-of select="r:data[@name = 'nic_brno']"/> / <xsl:value-of select="r:data[@name = 'ic_lcno']"/>
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:value-of select="r:data[@name = 'type']"/>
                            <xsl:if test="r:data[@name = 'guarantor'] = '1'">
                                (GUARANTOR)
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'source']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'date']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
                
            </table>

            <br/>

        </xsl:if>
        
    </xsl:template>
    <!-- finish trade_reference_sponsor -->

    <!-- start trade_reference_account_status -->
    <xsl:template name="trade_reference_account_status_template">
        
        <xsl:if test="r:enquiry/r:section[@id = 'account_status']">
            
            <xsl:for-each select="r:enquiry/r:section[@id = 'account_status']">
            
                <table class="table">
                    <tr>
                        <td class="header caption text-left">2. Aging Information</td>
                        <td class="long-content">
                            <xsl:if test="r:data[@name = 'statement_date'] != ''">
                                As At Statement Date: <xsl:value-of select="r:data[@name = 'statement_date']"/>
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'statement_date'] = ''">
                                Not Provided
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Name of Debtor</th>
                        <td class="long-content">
                            <xsl:value-of select="r:data[@name = 'debtor_name']"/>
                            <xsl:if test="r:data[@name = 'debtor_nic_brno'] != '' and r:data[@name = 'debtor_ic_lcno'] != ''">
                                (<xsl:value-of select="r:data[@name = 'debtor_nic_brno']"/> / <xsl:value-of select="r:data[@name = 'debtor_ic_lcno']"/>)
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'debtor_nic_brno'] != '' and r:data[@name = 'debtor_ic_lcno'] = ''">
                                (<xsl:value-of select="r:data[@name = 'debtor_nic_brno']"/>)
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'debtor_nic_brno'] = '' and r:data[@name = 'debtor_ic_lcno'] != ''">
                                (<xsl:value-of select="r:data[@name = 'debtor_ic_lcno']"/>)
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Credit Terms</th>
                        <td class="long-content">
                            <xsl:if test="r:data[@name = 'account_term'] &gt; '0'">
                                <xsl:value-of select="r:data[@name = 'account_term']"/> Days
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'account_term'] = '0'">
                                CASH
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Credit Limit</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'account_limit']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Account Status</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'account_status']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Address</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'address']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Nature of Debt</th>
                        <td class="long-content">
                            <xsl:value-of select="r:data[@name = 'debt_type']"/>
                        </td>
                    </tr>
                </table>
                
                <table class="table-text-right">
                    <tr>
                        <th>30 Days</th>
                        <th>60 Days</th>
                        <th>90 Days</th>
                        <th>120 Days</th>
                        <th>150 Days</th>
                        <th>180 Days</th>
                        <th>Over 180 Days</th>
                    </tr>
                    <tr>
                        <xsl:for-each select="r:data[@name = 'age']/r:item">
                            <td>
                                <xsl:call-template name="check_empty_number">
                                    <xsl:with-param name="number" select="."/>
                                </xsl:call-template>
                            </td>
                        </xsl:for-each>
                    </tr>
                </table>
                
                <p class="notice">The above was accurate as at the statement date indicate above.</p>
                
                <table class="table-text-center">
                    <tr>
                        <th>Account Conduct</th>
                        <th>Not Provided</th>
                        <th>Excellent</th>
                        <th>Good</th>
                        <th>Satisfactory</th>
                        <th>Unsatisfactory</th>
                    </tr>
                    <tr>
                        <td/>
                        <td>
                            <xsl:if test="r:data[@name = 'account_rating'] = '0'">
                                *
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:if test="r:data[@name = 'account_rating'] = '1'">
                                *
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:if test="r:data[@name = 'account_rating'] = '2'">
                                *
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:if test="r:data[@name = 'account_rating'] = '3'">
                                *
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:if test="r:data[@name = 'account_rating'] = '4'">
                                *
                            </xsl:if>
                        </td>
                    </tr>
                </table>

            </xsl:for-each>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish trade_reference_account_status -->

    <!-- start trade_reference_return_cheque -->
    <xsl:template name="trade_reference_return_cheque_template">
        
        <xsl:for-each select="r:enquiry/r:section[@id = 'return_cheque']">
        
            <table class="table">
                <tr>
                    <td class="header caption text-left">3. Returned Cheque Experience</td>
                    <td class="long-content">
                        <xsl:if test="@status != 'Not Provided'">
                            Details as follows: <xsl:value-of select="@status"/>
                        </xsl:if>
                        <xsl:if test="@status = 'Not Provided'">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="@status"/>
                            </xsl:call-template>
                        </xsl:if>
                    </td>
                </tr>
            </table>
        
        </xsl:for-each>
        
        <xsl:if test="r:enquiry/r:section[@id = 'return_cheque']/r:record">
                
            <table class="table-text-center">
                <tr>
                    <th>Cheque No.</th>
                    <th>Account No.</th>
                    <th>Bank</th>
                    <th>Amount (RM)</th>
                    <th>Date Returned</th>
                    <th>Reason</th>
                    <th>Cheque Issuer</th>
                </tr>
                <xsl:for-each select="r:enquiry/r:section[@id = 'return_cheque']/r:record">
                    <tr>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'cheque_no']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'cheque_acc_no']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'cheque_bank']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:data[@name = 'cheque_amount']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'cheque_date']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'cheque_reason']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'cheque_issuer']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
            
            <p class="notice">The above cheques were received for payment of amount owed but were returned unpaid for reasons indicated.</p>
            
        </xsl:if>
        
        <br/>
        
    </xsl:template>
    <!-- finish trade_reference_return_cheque -->

    <!-- start trade_reference_legal_action -->
    <xsl:template name="trade_reference_legal_action_template">
        
        <xsl:for-each select="r:enquiry/r:section[@id = 'legal_action']">
        
            <table class="table">
                <tr>
                    <td class="header caption text-left">4. Reminders / Letter of Demand for Payment / General Remarks</td>
                    <td class="long-content">
                        <xsl:if test="@status != 'Not Provided'">
                            Details as follows: <xsl:value-of select="@status"/>
                        </xsl:if>
                        <xsl:if test="@status = 'Not Provided'">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="@status"/>
                            </xsl:call-template>
                        </xsl:if>
                    </td>
                </tr>
            </table>
        
        </xsl:for-each>
        
        <xsl:if test="r:enquiry/r:section[@id = 'legal_action']/r:record">
                
            <table class="table">
                <xsl:for-each select="r:enquiry/r:section[@id = 'legal_action']/r:record">
                    <tr>
                        <td>
                            - <xsl:value-of select="r:data[@name = 'title']"/>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'date']"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'comment']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
            
        </xsl:if>
        
        <br/>
        
    </xsl:template>
    <!-- finish trade_reference_legal_action -->

    <!-- start trade_reference_contact -->
    <xsl:template name="trade_reference_contact_template">
        
        <xsl:if test="r:enquiry/r:section[@id = 'contact']">
            
            <xsl:variable name="ref_com_bus">
                <xsl:value-of select="r:header/r:ref_com_bus"/>
            </xsl:variable>
            
            <xsl:for-each select="r:enquiry/r:section[@id = 'contact']">
            
                <table class="table">
                    <tr>
                        <td class="header caption text-left">5. Referee's Request</td>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'type_desc']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Our contact is</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'name']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Address</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'address']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Our Reference</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:data[@name = 'reference']"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>

                        <th class="caption">
                            <xsl:if test="r:data[@name = 'type_code'] = '1' or r:data[@name = 'type_code'] >= '4'">
                                Tel
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'type_code'] = '2'">
                                Fax
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'type_code'] = '3'">
                                Email
                            </xsl:if>
                        </th>
                        <td class="long-content">
                            <xsl:if test="r:data[@name = 'type_code'] = '1' or r:data[@name = 'type_code'] >= '4'">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'tel_no']"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'type_code'] = '2'">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'fax_no']"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="r:data[@name = 'type_code'] = '3'">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:data[@name = 'email']"/>
                                </xsl:call-template>
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>

                        <th class="caption">Nature of Business</th>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="$ref_com_bus"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>

            </xsl:for-each>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish trade_reference_contact -->    

    <!-- start trade_reference_settlement -->
    <xsl:template name="trade_reference_settlement_template">

        <p class="notice">Important: Any indebtedness indicated above may have been subsequently settled, in which case, our official receipt or letter of discharge/settlement would have been issued to the subject. Please check with the subject.</p>
        <br/>

    </xsl:template>
    <!-- finish trade_reference_settlement -->

</xsl:stylesheet>
