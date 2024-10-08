PGDMP  '                    |            ProjetosSociais    16.3    16.3 !    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16394    ProjetosSociais    DATABASE     �   CREATE DATABASE "ProjetosSociais" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
 !   DROP DATABASE "ProjetosSociais";
                postgres    false            �           0    0    ProjetosSociais    DATABASE PROPERTIES     @   ALTER DATABASE "ProjetosSociais" SET "DateStyle" TO 'ISO, DMY';
                     postgres    false            �            1255    33210    atualizar_numerodedependentes()    FUNCTION       CREATE FUNCTION public.atualizar_numerodedependentes() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Atualiza o campo numerodedependentes na tabela beneficiario com a contagem de dependentes
    UPDATE beneficiario
    SET numerodedependentes = (
        SELECT COUNT(*)
        FROM dependentes
        WHERE cpfresponsavel = beneficiario.cpfbeneficiario
    );
END;
$$;
 6   DROP FUNCTION public.atualizar_numerodedependentes();
       public          postgres    false            �            1255    33211 '   atualizar_numerodedependentes_trigger()    FUNCTION     G  CREATE FUNCTION public.atualizar_numerodedependentes_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Chama a função que atualiza o número de dependentes
    PERFORM atualizar_numerodedependentes();
    RETURN NULL; -- Retorna NULL, pois o trigger é AFTER e não precisa modificar o registro.
END;
$$;
 >   DROP FUNCTION public.atualizar_numerodedependentes_trigger();
       public          postgres    false            �            1255    33222    atualizar_valortotalpago()    FUNCTION     �  CREATE FUNCTION public.atualizar_valortotalpago() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Atualiza a coluna valortotalpago com a multiplicação de numerodedependentes e valorextrapagopordependente
    -- somado ao valorbasepago
    UPDATE beneficiariobeneficios bb
    SET valortotalpago = COALESCE(
        (
            SELECT (ben.numerodedependentes * bn.valorextrapagopordependente) + bn.valorbasepago
            FROM beneficiario ben
            JOIN beneficios bn ON bb.codigobeneficio = bn.codigobeneficio
            WHERE ben.cpfbeneficiario = bb.cpfbeneficiario
            AND bn.codigobeneficio = bb.codigobeneficio
        ), 0 -- Caso não haja correspondência, define como 0
    );
END;
$$;
 1   DROP FUNCTION public.atualizar_valortotalpago();
       public          postgres    false            �            1255    33202    buscar_beneficios_ativos()    FUNCTION     K  CREATE FUNCTION public.buscar_beneficios_ativos() RETURNS TABLE(cpfbeneficiario character varying, nomebeneficiario character varying, codigobeneficio integer, nomebeneficio character varying, iniciodopagamento date, expiracaodobeneficio date, valorbasepago numeric, valorextrapagopordependente numeric, numerodedependetes numeric, valortotalpago numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        beneficiariobeneficios.cpfbeneficiario, 
        beneficiario.nomebeneficiario, 
        beneficiariobeneficios.codigobeneficio,
        beneficios.nomebeneficio, 
        beneficiariobeneficios.iniciodopagamento, 
        beneficiariobeneficios.expiracaodobeneficio,
		beneficios.valorbasepago,
		beneficios.valorextrapagopordependente,
		beneficiario.numerodedependentes,
		beneficiariobeneficios.valortotalpago
    FROM 
        beneficiariobeneficios
    JOIN 
        beneficiario ON beneficiariobeneficios.cpfbeneficiario = beneficiario.cpfbeneficiario
    JOIN 
        beneficios ON beneficiariobeneficios.codigobeneficio = beneficios.codigobeneficio;
END;
$$;
 1   DROP FUNCTION public.buscar_beneficios_ativos();
       public          postgres    false            �            1255    25064    buscar_endereco_beneficiario()    FUNCTION     �  CREATE FUNCTION public.buscar_endereco_beneficiario() RETURNS TABLE(cpfbeneficiario character varying, nomebeneficiario character varying, cep character varying, uf character varying, cidade character varying, bairro character varying, rua character varying, complemento character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        beneficiario.cpfbeneficiario, 
        beneficiario.nomebeneficiario, 
        endereco.cep, 
        endereco.uf, 
        endereco.cidade, 
        endereco.bairro, 
        endereco.rua, 
        endereco.complemento
    FROM 
        beneficiario
    JOIN 
        endereco ON beneficiario.enderecoid = endereco.enderecoid;
END;
$$;
 5   DROP FUNCTION public.buscar_endereco_beneficiario();
       public          postgres    false            �            1255    33225 #   executar_atualizar_valortotalpago()    FUNCTION     .  CREATE FUNCTION public.executar_atualizar_valortotalpago() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Chama a função para atualizar valortotalpago
    PERFORM public.atualizar_valortotalpago();
    
    RETURN NULL; -- Não modifica a linha atual, apenas executa a função
END;
$$;
 :   DROP FUNCTION public.executar_atualizar_valortotalpago();
       public          postgres    false            �            1259    17019    beneficiario    TABLE     �  CREATE TABLE public.beneficiario (
    cpfbeneficiario character varying(11) NOT NULL,
    nomebeneficiario character varying(100) NOT NULL,
    datadenascimentobeneficiario date NOT NULL,
    estadocivilbeneficiario character varying(50) NOT NULL,
    numerodedependentes numeric NOT NULL,
    enderecoid integer NOT NULL,
    numerodecontato character varying(15) NOT NULL,
    emaildecontato character varying(100)
);
     DROP TABLE public.beneficiario;
       public         heap    postgres    false            �            1259    17046    beneficiariobeneficios    TABLE     �   CREATE TABLE public.beneficiariobeneficios (
    cpfbeneficiario character varying(11) NOT NULL,
    codigobeneficio integer NOT NULL,
    iniciodopagamento date NOT NULL,
    expiracaodobeneficio date NOT NULL,
    valortotalpago numeric
);
 *   DROP TABLE public.beneficiariobeneficios;
       public         heap    postgres    false            �            1259    17039 
   beneficios    TABLE       CREATE TABLE public.beneficios (
    codigobeneficio integer NOT NULL,
    nomebeneficio character varying(100) NOT NULL,
    descricaobeneficio text NOT NULL,
    valorbasepago numeric(6,2) NOT NULL,
    valorextrapagopordependente numeric(6,2) NOT NULL
);
    DROP TABLE public.beneficios;
       public         heap    postgres    false            �            1259    17029    dependentes    TABLE     �   CREATE TABLE public.dependentes (
    cpfresponsavel character varying(11) NOT NULL,
    cpfdependente character varying(11) NOT NULL,
    nomedependente character varying(100) NOT NULL,
    datadenascimentodependente date NOT NULL
);
    DROP TABLE public.dependentes;
       public         heap    postgres    false            �            1259    17014    endereco    TABLE     U  CREATE TABLE public.endereco (
    enderecoid integer NOT NULL,
    cep character varying(9) NOT NULL,
    uf character varying(2) NOT NULL,
    cidade character varying(100) NOT NULL,
    bairro character varying(100) NOT NULL,
    rua character varying(100) NOT NULL,
    numero integer NOT NULL,
    complemento character varying(100)
);
    DROP TABLE public.endereco;
       public         heap    postgres    false            �          0    17019    beneficiario 
   TABLE DATA           �   COPY public.beneficiario (cpfbeneficiario, nomebeneficiario, datadenascimentobeneficiario, estadocivilbeneficiario, numerodedependentes, enderecoid, numerodecontato, emaildecontato) FROM stdin;
    public          postgres    false    216   �8       �          0    17046    beneficiariobeneficios 
   TABLE DATA           �   COPY public.beneficiariobeneficios (cpfbeneficiario, codigobeneficio, iniciodopagamento, expiracaodobeneficio, valortotalpago) FROM stdin;
    public          postgres    false    219   :       �          0    17039 
   beneficios 
   TABLE DATA           �   COPY public.beneficios (codigobeneficio, nomebeneficio, descricaobeneficio, valorbasepago, valorextrapagopordependente) FROM stdin;
    public          postgres    false    218   �:       �          0    17029    dependentes 
   TABLE DATA           p   COPY public.dependentes (cpfresponsavel, cpfdependente, nomedependente, datadenascimentodependente) FROM stdin;
    public          postgres    false    217   �;       �          0    17014    endereco 
   TABLE DATA           a   COPY public.endereco (enderecoid, cep, uf, cidade, bairro, rua, numero, complemento) FROM stdin;
    public          postgres    false    215   �<       2           2606    17023    beneficiario beneficiario_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.beneficiario
    ADD CONSTRAINT beneficiario_pkey PRIMARY KEY (cpfbeneficiario);
 H   ALTER TABLE ONLY public.beneficiario DROP CONSTRAINT beneficiario_pkey;
       public            postgres    false    216            6           2606    17045    beneficios beneficios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.beneficios
    ADD CONSTRAINT beneficios_pkey PRIMARY KEY (codigobeneficio);
 D   ALTER TABLE ONLY public.beneficios DROP CONSTRAINT beneficios_pkey;
       public            postgres    false    218            4           2606    17033    dependentes dependentes_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.dependentes
    ADD CONSTRAINT dependentes_pkey PRIMARY KEY (cpfdependente);
 F   ALTER TABLE ONLY public.dependentes DROP CONSTRAINT dependentes_pkey;
       public            postgres    false    217            0           2606    17018    endereco endereco_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (enderecoid);
 @   ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
       public            postgres    false    215            <           2620    33216 -   dependentes trg_atualizar_numerodedependentes    TRIGGER     �   CREATE TRIGGER trg_atualizar_numerodedependentes AFTER INSERT OR DELETE OR UPDATE ON public.dependentes FOR EACH ROW EXECUTE FUNCTION public.atualizar_numerodedependentes_trigger();
 F   DROP TRIGGER trg_atualizar_numerodedependentes ON public.dependentes;
       public          postgres    false    217    233            ;           2620    33228 -   beneficiario trigger_atualizar_valortotalpago    TRIGGER     �   CREATE TRIGGER trigger_atualizar_valortotalpago AFTER UPDATE ON public.beneficiario FOR EACH STATEMENT EXECUTE FUNCTION public.executar_atualizar_valortotalpago();
 F   DROP TRIGGER trigger_atualizar_valortotalpago ON public.beneficiario;
       public          postgres    false    221    216            >           2620    33226 +   beneficios trigger_atualizar_valortotalpago    TRIGGER     �   CREATE TRIGGER trigger_atualizar_valortotalpago AFTER UPDATE ON public.beneficios FOR EACH STATEMENT EXECUTE FUNCTION public.executar_atualizar_valortotalpago();
 D   DROP TRIGGER trigger_atualizar_valortotalpago ON public.beneficios;
       public          postgres    false    218    221            =           2620    33227 ,   dependentes trigger_atualizar_valortotalpago    TRIGGER     �   CREATE TRIGGER trigger_atualizar_valortotalpago AFTER UPDATE ON public.dependentes FOR EACH STATEMENT EXECUTE FUNCTION public.executar_atualizar_valortotalpago();
 E   DROP TRIGGER trigger_atualizar_valortotalpago ON public.dependentes;
       public          postgres    false    221    217            7           2606    17024 )   beneficiario beneficiario_enderecoid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.beneficiario
    ADD CONSTRAINT beneficiario_enderecoid_fkey FOREIGN KEY (enderecoid) REFERENCES public.endereco(enderecoid);
 S   ALTER TABLE ONLY public.beneficiario DROP CONSTRAINT beneficiario_enderecoid_fkey;
       public          postgres    false    216    215    4656            9           2606    17054 B   beneficiariobeneficios beneficiariobeneficios_codigobeneficio_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.beneficiariobeneficios
    ADD CONSTRAINT beneficiariobeneficios_codigobeneficio_fkey FOREIGN KEY (codigobeneficio) REFERENCES public.beneficios(codigobeneficio);
 l   ALTER TABLE ONLY public.beneficiariobeneficios DROP CONSTRAINT beneficiariobeneficios_codigobeneficio_fkey;
       public          postgres    false    218    4662    219            :           2606    17049 B   beneficiariobeneficios beneficiariobeneficios_cpfbeneficiario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.beneficiariobeneficios
    ADD CONSTRAINT beneficiariobeneficios_cpfbeneficiario_fkey FOREIGN KEY (cpfbeneficiario) REFERENCES public.beneficiario(cpfbeneficiario);
 l   ALTER TABLE ONLY public.beneficiariobeneficios DROP CONSTRAINT beneficiariobeneficios_cpfbeneficiario_fkey;
       public          postgres    false    4658    216    219            8           2606    17034 ,   dependentes dependentes_cpfresponsável_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dependentes
    ADD CONSTRAINT "dependentes_cpfresponsável_fkey" FOREIGN KEY (cpfresponsavel) REFERENCES public.beneficiario(cpfbeneficiario);
 X   ALTER TABLE ONLY public.dependentes DROP CONSTRAINT "dependentes_cpfresponsável_fkey";
       public          postgres    false    217    4658    216            �   4  x�U�MN�0�דS�����ށ�B !*�b3M�r����l{1�ĥ��������5mSk%����T޹1���	�DMOn�t��B*]7-t��=;��;�.�?X�uq�q���Hg|k�L*X�w}D� AQn��[6Vx1.R�!VJx�sظ��Y�匷�[��!v}��A�SN�]�Tq�,�g�Q
1v�c�
��J��^��Ls�e���!��z��Z�}�ˇ~HHC]&,����#�@����ĕ'���x��PR���q^���r���m��.1C5%��ZE�m��      �   w   x�}�1!��bF�͝�K�����I�N�J����Y-
��\Q&�r3Z�:"5&N��M�w4�9���8��>q�/��t���b�Nm�@p	��c��m?D?ۈ�}��j��?0�      �   H  x���;N1�k�)���!��	*U��=K��@��@B�)|1��

��������p�r: ܠ�'��]�C�p�*�V����ڱ# *&���@�$m��Fi%QR�.��n�]�x��ƞ�a$o�>�"Km>��&\ђJ:�oL�[��9��E&)Ԍ���Ï��)��y(�q4w�lT6������J�S��Δ�V	�?�Pؑ6����?�s����6��_h�X{?\T�qKO���½*�툼� g?�{�8�rm�f.�4X�TTvI�V��E �I�Lm$(N�瓓}�� �!�_2��z�jvɗ�b9�[�UU}E��;      �   �   x�U�=j1�zt
]@a4�/�4�p�f�( �D�u��[����L�>oR�YC�&2�Z�<l�/��&���5*tʠX�)Kڇ�-�?�Z�s'�κ�R;�P�Z���������V���t�kQP�U�Rr5��S��B���w� ;n�^m� *Z��S@�<�Q~�ܗz��\��G^�=JM`      �   5  x�]�AN�0E��S� �'N�m����U7�Ƣ��L��]pX��N	���{޼�
����5�y����dK��d	��B���>�F�ɵԟn��:�CyYf�D
�U��
�qk�X޳��h"�B�`a"����&T�Pqc�<�Td�BԘ�
��A�mCP�~�,��z�ql֪����-��Ȳ�&@/Y;>�,�fW�*ziXjD�����b�l���	Ul܉�[o߂ ��'��|Y$�S��ɲ��^m�?��ڝcK3c���
���SQ��2�'�b�o����q����u�\B�/��{7     