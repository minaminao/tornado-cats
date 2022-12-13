<div align="center"><img src="Tornado%20Cats.png" style="width: 512px;"></div><br>


**Tornado Cats** is a book for learning zero-knowledge applications and decentralized mixing through the creation of a simple mixer protocol based on [Tornado Cash](https://github.com/tornadocash/tornado-core). This is still under construction.

> **Warning**
> This repository is for educational purposes only and is not intended to facilitate attacks against protocols and money laundering.

---

**目次**
1. [はじめに](#%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB)
2. [ハンズオンの進め方](#%E3%83%8F%E3%83%B3%E3%82%BA%E3%82%AA%E3%83%B3%E3%81%AE%E9%80%B2%E3%82%81%E6%96%B9)
3. [Tornado Cashの概要](#tornado-cash%E3%81%AE%E6%A6%82%E8%A6%81)
   1. [Tornado Cashとは](#tornado-cash%E3%81%A8%E3%81%AF)
   2. [秘匿化の仕組み](#%E7%A7%98%E5%8C%BF%E5%8C%96%E3%81%AE%E4%BB%95%E7%B5%84%E3%81%BF)
   3. [リレイヤー](#%E3%83%AA%E3%83%AC%E3%82%A4%E3%83%A4%E3%83%BC)
   4. [ミキシング](#%E3%83%9F%E3%82%AD%E3%82%B7%E3%83%B3%E3%82%B0)
   5. [匿名性が失われる不適切な利用](#%E5%8C%BF%E5%90%8D%E6%80%A7%E3%81%8C%E5%A4%B1%E3%82%8F%E3%82%8C%E3%82%8B%E4%B8%8D%E9%81%A9%E5%88%87%E3%81%AA%E5%88%A9%E7%94%A8)
   6. [Tornado Cash ClassicとTornado Cash Nova](#tornado-cash-classic%E3%81%A8tornado-cash-nova)
4. [ゼロ知識証明の概要](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%AE%E6%A6%82%E8%A6%81)
   1. [ゼロ知識証明とは](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%A8%E3%81%AF)
   2. [ゼロ知識証明が満たすべき3つの性質](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%8C%E6%BA%80%E3%81%9F%E3%81%99%E3%81%B9%E3%81%8D3%E3%81%A4%E3%81%AE%E6%80%A7%E8%B3%AA)
      1. [完全性（Completeness）](#%E5%AE%8C%E5%85%A8%E6%80%A7completeness)
      2. [健全性（Soundness）](#%E5%81%A5%E5%85%A8%E6%80%A7soundness)
      3. [ゼロ知識性（Zero-knowledge Property）](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E6%80%A7zero-knowledge-property)
      4. [具体例: 匿名送金の場合](#%E5%85%B7%E4%BD%93%E4%BE%8B-%E5%8C%BF%E5%90%8D%E9%80%81%E9%87%91%E3%81%AE%E5%A0%B4%E5%90%88)
   3. [どうしたらゼロ知識証明が構成できるか](#%E3%81%A9%E3%81%86%E3%81%97%E3%81%9F%E3%82%89%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%8C%E6%A7%8B%E6%88%90%E3%81%A7%E3%81%8D%E3%82%8B%E3%81%8B)
      1. [問題の定義](#%E5%95%8F%E9%A1%8C%E3%81%AE%E5%AE%9A%E7%BE%A9)
      2. [駄目な例](#%E9%A7%84%E7%9B%AE%E3%81%AA%E4%BE%8B)
      3. [良い例](#%E8%89%AF%E3%81%84%E4%BE%8B)
   4. [非対話型ゼロ知識証明](#%E9%9D%9E%E5%AF%BE%E8%A9%B1%E5%9E%8B%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E)
   5. [zk-SNARK](#zk-snark)
5. [環境構築](#%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89)
6. [ゼロ知識証明回路の基礎](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E5%9B%9E%E8%B7%AF%E3%81%AE%E5%9F%BA%E7%A4%8E)
   1. [回路とは](#%E5%9B%9E%E8%B7%AF%E3%81%A8%E3%81%AF)
   2. [Circomとは](#circom%E3%81%A8%E3%81%AF)
   3. [回路の例: 因数分解](#%E5%9B%9E%E8%B7%AF%E3%81%AE%E4%BE%8B-%E5%9B%A0%E6%95%B0%E5%88%86%E8%A7%A3)
   4. [回路のコンパイル](#%E5%9B%9E%E8%B7%AF%E3%81%AE%E3%82%B3%E3%83%B3%E3%83%91%E3%82%A4%E3%83%AB)
   5. [Rank 1 Constraint System (R1CS)](#rank-1-constraint-system-r1cs)
   6. [ウィットネスの計算](#%E3%82%A6%E3%82%A3%E3%83%83%E3%83%88%E3%83%8D%E3%82%B9%E3%81%AE%E8%A8%88%E7%AE%97)
   7. [ゼロ知識証明のセットアップ](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%AE%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97)
      1. [Trusted Setup](#trusted-setup)
      2. [Trusted Setup Ceremony](#trusted-setup-ceremony)
      3. [Phase 1](#phase-1)
      4. [Phase 2](#phase-2)
   8. [ゼロ知識証明の生成](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%AE%E7%94%9F%E6%88%90)
   9. [ゼロ知識証明の検証](#%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E3%81%AE%E6%A4%9C%E8%A8%BC)
   10. [演習: 3個の入力シグナルを持つ乗算器](#%E6%BC%94%E7%BF%92-3%E5%80%8B%E3%81%AE%E5%85%A5%E5%8A%9B%E3%82%B7%E3%82%B0%E3%83%8A%E3%83%AB%E3%82%92%E6%8C%81%E3%81%A4%E4%B9%97%E7%AE%97%E5%99%A8)
   11. [演習: N個の入力シグナルを持つ乗算器](#%E6%BC%94%E7%BF%92-n%E5%80%8B%E3%81%AE%E5%85%A5%E5%8A%9B%E3%82%B7%E3%82%B0%E3%83%8A%E3%83%AB%E3%82%92%E6%8C%81%E3%81%A4%E4%B9%97%E7%AE%97%E5%99%A8)
   12. [演習: 入力シグナルが真偽値かをチェックする回路](#%E6%BC%94%E7%BF%92-%E5%85%A5%E5%8A%9B%E3%82%B7%E3%82%B0%E3%83%8A%E3%83%AB%E3%81%8C%E7%9C%9F%E5%81%BD%E5%80%A4%E3%81%8B%E3%82%92%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF%E3%81%99%E3%82%8B%E5%9B%9E%E8%B7%AF)
   13. [演習: 論理AND回路](#%E6%BC%94%E7%BF%92-%E8%AB%96%E7%90%86and%E5%9B%9E%E8%B7%AF)
   14. [演習: N入力の論理AND回路（オプション）](#%E6%BC%94%E7%BF%92-n%E5%85%A5%E5%8A%9B%E3%81%AE%E8%AB%96%E7%90%86and%E5%9B%9E%E8%B7%AF%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3)
7. [自作ミキサープロトコルの構成](#%E8%87%AA%E4%BD%9C%E3%83%9F%E3%82%AD%E3%82%B5%E3%83%BC%E3%83%97%E3%83%AD%E3%83%88%E3%82%B3%E3%83%AB%E3%81%AE%E6%A7%8B%E6%88%90)
   1. [基本方針](#%E5%9F%BA%E6%9C%AC%E6%96%B9%E9%87%9D)
   2. [演習: ミキサープロトコルの設計](#%E6%BC%94%E7%BF%92-%E3%83%9F%E3%82%AD%E3%82%B5%E3%83%BC%E3%83%97%E3%83%AD%E3%83%88%E3%82%B3%E3%83%AB%E3%81%AE%E8%A8%AD%E8%A8%88)
   3. [プロトコルの全体構成](#%E3%83%97%E3%83%AD%E3%83%88%E3%82%B3%E3%83%AB%E3%81%AE%E5%85%A8%E4%BD%93%E6%A7%8B%E6%88%90)
   4. [コントラクト構成](#%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E6%A7%8B%E6%88%90)
   5. [回路構成](#%E5%9B%9E%E8%B7%AF%E6%A7%8B%E6%88%90)
8. [入出金の設計](#%E5%85%A5%E5%87%BA%E9%87%91%E3%81%AE%E8%A8%AD%E8%A8%88)
   1. [演習: 入出金操作の設計](#%E6%BC%94%E7%BF%92-%E5%85%A5%E5%87%BA%E9%87%91%E6%93%8D%E4%BD%9C%E3%81%AE%E8%A8%AD%E8%A8%88)
   2. [駄目な設計例](#%E9%A7%84%E7%9B%AE%E3%81%AA%E8%A8%AD%E8%A8%88%E4%BE%8B)
   3. [駄目な設計例2](#%E9%A7%84%E7%9B%AE%E3%81%AA%E8%A8%AD%E8%A8%88%E4%BE%8B2)
   4. [良い設計例](#%E8%89%AF%E3%81%84%E8%A8%AD%E8%A8%88%E4%BE%8B)
   5. [アルゴリズムとデータ構造の選定](#%E3%82%A2%E3%83%AB%E3%82%B4%E3%83%AA%E3%82%BA%E3%83%A0%E3%81%A8%E3%83%87%E3%83%BC%E3%82%BF%E6%A7%8B%E9%80%A0%E3%81%AE%E9%81%B8%E5%AE%9A)
   6. [Pedersenハッシュとは](#pedersen%E3%83%8F%E3%83%83%E3%82%B7%E3%83%A5%E3%81%A8%E3%81%AF)
   7. [MiMC Merkleツリーとは](#mimc-merkle%E3%83%84%E3%83%AA%E3%83%BC%E3%81%A8%E3%81%AF)
9. [出金回路の実装](#%E5%87%BA%E9%87%91%E5%9B%9E%E8%B7%AF%E3%81%AE%E5%AE%9F%E8%A3%85)
   1. [演習: シグナルの定義とコンポーネントの作成](#%E6%BC%94%E7%BF%92-%E3%82%B7%E3%82%B0%E3%83%8A%E3%83%AB%E3%81%AE%E5%AE%9A%E7%BE%A9%E3%81%A8%E3%82%B3%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%8D%E3%83%B3%E3%83%88%E3%81%AE%E4%BD%9C%E6%88%90)
   2. [演習: ヌリファイアのチェック](#%E6%BC%94%E7%BF%92-%E3%83%8C%E3%83%AA%E3%83%95%E3%82%A1%E3%82%A4%E3%82%A2%E3%81%AE%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF)
   3. [演習: MiMC Merkleツリーのチェック](#%E6%BC%94%E7%BF%92-mimc-merkle%E3%83%84%E3%83%AA%E3%83%BC%E3%81%AE%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF)
   4. [演習: 受信者・手数料・リレイヤーのチェック](#%E6%BC%94%E7%BF%92-%E5%8F%97%E4%BF%A1%E8%80%85%E3%83%BB%E6%89%8B%E6%95%B0%E6%96%99%E3%83%BB%E3%83%AA%E3%83%AC%E3%82%A4%E3%83%A4%E3%83%BC%E3%81%AE%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF)
10. [コントラクト開発の基礎](#%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E9%96%8B%E7%99%BA%E3%81%AE%E5%9F%BA%E7%A4%8E)
    1. [コントラクト開発の流れ](#%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E9%96%8B%E7%99%BA%E3%81%AE%E6%B5%81%E3%82%8C)
    2. [Solidityについて](#solidity%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)
    3. [Foundryについて](#foundry%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)
11. [プールコントラクトの実装](#%E3%83%97%E3%83%BC%E3%83%AB%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E3%81%AE%E5%AE%9F%E8%A3%85)
    1. [コントラクトのテスト](#%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88)
    2. [演習: `TornadoCats`コントラクトのインターフェース](#%E6%BC%94%E7%BF%92-tornadocats%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%BF%E3%83%BC%E3%83%95%E3%82%A7%E3%83%BC%E3%82%B9)
    3. [演習: `deposit`関数](#%E6%BC%94%E7%BF%92-deposit%E9%96%A2%E6%95%B0)
    4. [演習: `withdraw`関数](#%E6%BC%94%E7%BF%92-withdraw%E9%96%A2%E6%95%B0)
12. [付録](#%E4%BB%98%E9%8C%B2)
    1. [Tornado Cashの非中央集権性](#tornado-cash%E3%81%AE%E9%9D%9E%E4%B8%AD%E5%A4%AE%E9%9B%86%E6%A8%A9%E6%80%A7)
    2. [Tornado Cashの稼働ネットワークと対応通貨](#tornado-cash%E3%81%AE%E7%A8%BC%E5%83%8D%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%81%A8%E5%AF%BE%E5%BF%9C%E9%80%9A%E8%B2%A8)
    3. [Tornado Cashの主要コントラクトアドレス](#tornado-cash%E3%81%AE%E4%B8%BB%E8%A6%81%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9)
    4. [Tornado Cashの主要リポジトリ一覧](#tornado-cash%E3%81%AE%E4%B8%BB%E8%A6%81%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E4%B8%80%E8%A6%A7)
    5. [Tornado Cash Classicのコントラクト](#tornado-cash-classic%E3%81%AE%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88)
       1. [コントラクト構成](#%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E6%A7%8B%E6%88%90-1)
       2. [`Pairing`ライブラリ](#pairing%E3%83%A9%E3%82%A4%E3%83%96%E3%83%A9%E3%83%AA)
       3. [`Verifier`コントラクト](#verifier%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88)
    6. [Tornado Cash Classicのゼロ知識証明回路](#tornado-cash-classic%E3%81%AE%E3%82%BC%E3%83%AD%E7%9F%A5%E8%AD%98%E8%A8%BC%E6%98%8E%E5%9B%9E%E8%B7%AF)
       1. [回路構成](#%E5%9B%9E%E8%B7%AF%E6%A7%8B%E6%88%90-1)
       2. [`CommitmentHasher`テンプレート](#commitmenthasher%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
       3. [`Withdraw`テンプレート](#withdraw%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
       4. [`MerkleTreeChecker`テンプレート](#merkletreechecker%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
       5. [`DualMax`テンプレート](#dualmax%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
       6. [`HashLeftRight`テンプレート](#hashleftright%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
    7. [CircomLib](#circomlib)
       1. [`MiMCSponge`テンプレート](#mimcsponge%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
       2. [`Pedersen`テンプレート](#pedersen%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
       3. [`Num2Bits`テンプレート](#num2bits%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
    8. [Tornado Cash ClassicのTrusted Setup Ceremony](#tornado-cash-classic%E3%81%AEtrusted-setup-ceremony)
    9. [Tornado Cashのガバナンス](#tornado-cash%E3%81%AE%E3%82%AC%E3%83%90%E3%83%8A%E3%83%B3%E3%82%B9)
    10. [zk-SNARK用のプリコンパイル済みコントラクト](#zk-snark%E7%94%A8%E3%81%AE%E3%83%97%E3%83%AA%E3%82%B3%E3%83%B3%E3%83%91%E3%82%A4%E3%83%AB%E6%B8%88%E3%81%BF%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88)
13. [参考文献](#%E5%8F%82%E8%80%83%E6%96%87%E7%8C%AE)

---

# はじめに

この資料はyoshi-camp 2022での資料で、学習時間の目安は180分です
（yoshi-camp参加者用: [Introduction Slide](https://docs.google.com/presentation/d/1JXbbLLLAxwQKw_ECfV4x_xfMv7vjQknHlrFQ-gDtvOA/edit?usp=sharing)）。

Tornado Cashは、プライバシー保護の強力さから犯罪資金（特にブロックチェーン上の攻撃で得られたトークン）のマネーロンダリングに利用されてしまうことで有名ですが、ゼロ知識アプリケーションとして学べるものが多いです。このハンズオンでは、Tornado Cash型のシンプルなミキサープロトコルの実装を通して、ゼロ知識アプリケーションと非中央集権型のミキシングについて学ぶことを目的としています。

# ハンズオンの進め方

実際にミキサープロトコルを自作していく前に、Tornado Cashとゼロ知識証明をまだあまり知らない人に向けて、簡単にTornado Cashとゼロ知識証明の説明をします。それで何を作るのかをある程度掴んでもらった上で、実際に開発を進めていきます。開発は基本的に「理論・ツールの説明」➔「設計・実装」のサイクルになるように行います。ある設計・実装に必要な理論的な知識はできるだけその直前に説明します。適宜演習を挟みます。

# Tornado Cashの概要

## Tornado Cashとは

Tornado Cashは、ブロックチェーン上で暗号資産の送金を匿名化するプロトコルです。具体的には、送信者視点で「誰に送ったか」と受信者視点で「誰から受け取ったか」を秘匿化するプロトコルです。受け取った額は秘匿化されません。Tornado Cashは非中央集権的に運用されており、既にデプロイされたコントラクトの挙動は変更できなくなっています。（詳しくは[Tornado Cashの非中央集権性](#tornado-cash%E3%81%AE%E9%9D%9E%E4%B8%AD%E5%A4%AE%E9%9B%86%E6%A8%A9%E6%80%A7)を参照してください。）

現在はEthereumを初め様々なブロックチェーンにデプロイされており、Ether以外にも様々なERC-20トークンに対応しています。（詳しくは[Tornado Cashの稼働ネットワークと対応通貨](#tornado-cash%E3%81%AE%E7%A8%BC%E5%83%8D%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%81%A8%E5%AF%BE%E5%BF%9C%E9%80%9A%E8%B2%A8)と[Tornado Cashの主要コントラクトアドレス](#tornado-cash%E3%81%AE%E4%B8%BB%E8%A6%81%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9)を参照してください。）

## 秘匿化の仕組み

Tornado Cashの秘匿化は、送信者アドレスと受信者アドレスのオンチェーンでの結びつきをゼロ知識証明によって無くすことで実現しています。

Tornado Cashを利用する流れは例えば次のようなものになります。
1. 送信者アドレスからTornado Cashコントラクトへ1 ETH送るトランザクションを送信する。ローカルでは、その資金を引き出す際に提出する「ノート」と呼ばれるデータを保管する。
2. （受信者が他人であればオフチェーンでノートを渡す。）
3. 受信者アドレスからTornado Cashコントラクトへそのノートを添付したトランザクションを送信し、1 ETHを受け取る。

ここで、Etherを受け取るための証明として提出するノートから送信者アドレスを求めることはゼロ知識証明技術によりできないようになっています。第三者の視点で入金と出金が独立になり、出金トランザクションから入金トランザクションを知ることができないため、「送信者アドレスがどのアドレスに送ったか」と「受信者アドレスがどのアドレスから受け取ったか」がわからなくなります。

## リレイヤー

上記の例では、受信者アドレスがトランザクションを送信するためにあらかじめガス代としてEtherを所持しておく必要があります。しかし、そのEtherを用意するために中央集権取引所などを利用してしまってはプライバシーという観点で本末転倒です。この問題を解決するために、Tornado Cashでは「リレイヤー」（Relayer）という存在がいます。リレイヤーは送金手数料をもらう対価として、受信者の代わりにトランザクションの送信をしてくれます。このリレイヤーがいるおかげでプライバシーが向上しています。リレイヤーにはガバナンストークンであるTORNをロックするとなれます。

## ミキシング

Tornado Cashで利用されている匿名化手法はミキシング（Mixing）と呼ばれます。そのため入金するプールはミキサーとも呼ばれます。

![](https://i.gyazo.com/c27b46832b43453394a1b5ba89205b50.png)

プールにある自分のトークンは完全に自分のコントロール下にあり、第三者に操作されることはありません（言い換えるとカストディがあります）。

Tornado Cashの秘匿化が実現するのは、プロトコルの利用者数が十分であり、利用者が正しく利用した時に限ります。不適切な利用をした場合は匿名化を破ることが可能です。

## 匿名性が失われる不適切な利用

不適切な利用として、特に以下のケースに気をつけてください。
- リレイヤーを使用せず過去のトランザクション履歴に個人を特定できる情報がある
- 入金から出金までの時間が短すぎる
- 受信者アドレスを分散させず、送信者アドレスからの総入金額と受信者アドレスへの総出金額が等しい（あるいはほぼ等しい）

後半2つの手法のようにミキサーへの入出金を統計的に分析することで受信者アドレスを推定する手法はDe-mixingと呼ばれます。

他に、ブロックチェーンとは関係ないですが、Torやプライバシー保護のVPN（ログを保管しないことを謳うもの）を利用しないことが挙げられます。

## Tornado Cash ClassicとTornado Cash Nova

Tornado Cashには大きく2つのバージョンがあります。Tornado Cash ClassicとTornado Cash Novaです。Tornado Cash Novaは2021年12月にリリースされた新しいバージョンで、それと対比して従来のTornado CashをTornado Cash Classicと呼びます。

Tornado Cash Classicでは固定額の入出金しかできません。例えば、Etherであれば0.1 ETH, 1 ETH, 10 ETH, 100 ETHの4種類のプールを選択して利用する必要があります。2.4 ETHを送金したいなら、
- 1 ETHのプールに2回入金
- 0.1 ETHのプールに4回入金

といったように分割した入金をしなければなりません。Tornado Cash Novaでは、Tornado Cash Classicとは異なり任意の金額の送金が可能です。

またTornado Cash Novaでは、プール内での送金が可能です。Tornado Cash Classicでは送金を完了するには、一度プールから出金する必要があります。Tornado Cash Novaでは、プールしている額のうちの任意の金額を、プールから出金せずに別のアドレスに移すことができる。これはShielded Transferと呼ばれます。

本資料ではTornado Cash Classicと同様の「固定額の入出金」かつ「Shielded Transferのない」シンプルなミキサープロトコルを実装します。

# ゼロ知識証明の概要

## ゼロ知識証明とは

ゼロ知識証明とは、ある人が他の人に対して証明したい命題を、その命題が真である以外の情報（知識）を開示することなく証明する手法のことです。ここでの「ある人」を証明者、「他の人」を検証者と呼びます。

ゼロ知識証明はその便利な性質が注目され、プライバシー保護技術として利用されています。また、プライバシー保護だけでなく計算結果を高速に検算できるという性質があり、特にブロックチェーンにおいてスケーラビリティを向上する技術としても利用されています。

## ゼロ知識証明が満たすべき3つの性質

ゼロ知識証明は基本的に「完全性」「健全性」「ゼロ知識性」の3つの性質を満たすものです。

### 完全性（Completeness）

証明者が提示する命題が真である場合、検証者は真であることが必ずわかること。

### 健全性（Soundness）

証明者が提示する命題が偽である場合、検証者は高い確率で偽であることがわかること。

### ゼロ知識性（Zero-knowledge Property）

証明者が提示する命題が真である場合、検証者は真である以外の情報がわからないこと。

### 具体例: 匿名送金の場合

これら3つの性質をAliceからBobへの匿名送金で考えてみましょう。
- **完全性**: Bobが正当な出金要求を送った場合、プールはBobが送信してきた出金要求が正しいものであると必ずわかること。
- **健全性**: Bobが不正な出金要求を送った場合、プールはBobが送信してきた出金要求が正しくないものであると高い確率でわかること。
- **ゼロ知識性**: Bobが正当な出金要求を送った場合、プールはBobが送信してきた出金要求が正しいものであること以外の情報がわからないこと。ここでの情報とは、例えば「入金者が誰であるか」「いつ入金されたか」などです。

## どうしたらゼロ知識証明が構成できるか

既に完成されたゼロ知識証明を見ていく前に、ちょっとだけどうしたらゼロ知識証明が構成できるか考えてみましょう。

### 問題の定義

まず、問題を簡単に定義します。 AliceとBobが居て、それぞれ秘密の値 $a,b$ を持っていて、2人とも秘密の値を明かしたくないが、この秘密の値が一致しているかどうかを知りたいとします。この場合どういった手法が考えられるでしょうか。

### 駄目な例

AliceかBobが秘密の値を相手に送るのは当然駄目なので、何かしら秘密の値を加工すれば良いのではないでしょうか。そこで、暗号学的ハッシュ関数 $H$ を利用する方針を考えてみます。

Aliceが $H(a)$ をBobに送り、Bobが手元で $H(a) = H(b)$ を確認すれば、暗号学的ハッシュ関数の性質によりプリイメージの逆算が困難なので、秘密の値を隠したまま両者の秘密の値 $a,b$ が一致するかどうかがわかります。これはゼロ知識証明と言えるでしょうか。

答えはNoです。なぜならAliceのハッシュ値がBobに知られてしまっているためです。「AliceとBobの秘密の値が一致する」という情報以外に、「Aliceのハッシュ値」という情報が漏れており、ゼロ知識性を満たさないのです。

### 良い例

それでは、ゼロ知識性を満たすようにこの命題を証明するにはどうしたら良いでしょうか。

それを説明する前に、まずは問題を扱いやすい別の形に変換します。今回はAliceが証明者、Bobが検証者として、「Aliceが秘密の値 $x$ を知っていること」をゼロ知識証明することにします。この命題は $p$ を素数とする有限体 $\mathbb{F_p}$ において「Aliceが $g^x \pmod p$ の $x$ を知っていること」と変換できます。 $g$ は $\mathbb{F_p}$ の元で、 $g$ と $p$ は2人に共有されています。

この問題を解くには、次のような手順を踏めば良いです。

1. Aliceは一時的な乱数 $r$ を生成します。この $r$ は、 $q$ を $g^q = 1$ となる最小の自然数、すなわち $\mathbb{F}_p$ における $g$ の位数として、 $0$ から $q-1$ の範囲で選びます。そして $c = g^r$ をBobに送ります。
2. Bobは一時的な乱数 $e$ を $0$ から $q-1$ の範囲で生成し、Aliceに送ります。
3. Aliceは $z = r + ex$ をBobに送ります。
4. Bobは $g^z = cy^e$ が真か確かめます。
$g^z$ は、 $g^z = g^{r+ex}=g^r\cdot (g^x)^e = cy^e$ と変形でき、もしAliceが秘密の値 $x$ を知っているならば、これは一致します。

この手順はSchnorrプロトコルと呼ばれ、先程紹介した3つの性質を満たしたしています。実際に満たしていることを確認してみると良いでしょう。

## 非対話型ゼロ知識証明

Schnorrプロトコルは見たら分かるとおり、AliceとBobが対話しているため対話型ゼロ知識証明と呼ばれます。ただ、この対話型という性質は分散システム、特にブロックチェーンのスマートコントラクトと非常に相性が悪いです。トランザクションを送信して、トランザクションがブロックに含まれて実行されて、その実行された結果を見てまたトランザクションを送信して、……と考えただけで嫌になります。また、そもそも1つのトランザクションで完結しなければいけない場合に対応できません。

そのような課題を解決するために、非対話型のゼロ知識証明があります。ペアリングを使ったり、ハッシュ関数を利用したりすると、対話型ゼロ知識証明を非対話型ゼロ知識証明に変換できます。今回のハンズオンでは、zk-SNARKというタイプの非対話型ゼロ知識証明を利用しますが、ペアリングを用いています。

## zk-SNARK

Zero-Knowledge Succinct Non-Interactive Argument of Knowledge、略してzk-SNARKは、非対話型ゼロ知識証明のカテゴリーの一つです。完全性、健全性、ゼロ知識性に加えて、簡潔性（Succinct Property）を持ち、名前の由来にもなっています。zk-SNARKであるプロトコルをまとめてzk-SNARKsと呼びます。

簡潔性は、証明のサイズが一定サイズであるという性質です。これはブロックチェーンと非常に相性が良いです。ブロックチェーンでは処理するデータのサイズによってトランザクション手数料が増加します。簡潔性があればどれだけ証明が複雑であろうとも、その手数料が一定であることが保証されるのです。

今回のハンズオンでは2016年にJens Grothによって発表された[Groth16](https://eprint.iacr.org/2016/260.pdf)と呼ばれるzk-SNARKを利用します。

# 環境構築

Tornado Cashとゼロ知識証明について最低限の知識は共有したので、ミキサープロトコルを自作していきたいと思います。まずは環境構築をしていきましょう。インストールが必要なツールが色々とありますが、[Dockerfile](Dockerfile)を用意したのでそれを利用すれば一括でインストールできます。万が一ビルドに失敗する場合はDockerfileを参考に各ツールをネイティブOSにインストールしてください。基本的にはネイティブOS上で開発して、コンテナでアプリケーションの実行をするという形で進めます。

このリポジトリ配下で次のコマンドを実行してください。Dockerイメージのビルド、Dockerコンテナの作成・起動が行われます。

```
docker build . -t tornado-cats
docker create --name tornado-cats -v $(pwd):/home/cat/tornado-cats -it tornado-cats
docker start -ai tornado-cats
```

`docker create`コマンドで`-v`オプションを指定することで、tornado-catsリポジトリのファイルがユーザーcatのホームディレクトリ配下のtornado-catsディレクトリにマウントされます。マウントしたディレクトリを介してデータのやり取りをします。もしログアウトした場合は再度`docker start -ai tornado-cats`を実行してください。`docker run`は環境の引き継ぎができないので使いません。再度ビルドしてコンテナを作成し直したい場合は`docker rm tornado-cats`すると良いです。

# ゼロ知識証明回路の基礎

## 回路とは

ミキサープロトコルの実装をするためにはゼロ知識証明を生成するプログラムを作成しなければなりません。そのようなプログラムを回路と呼びます。回路は、命題を計算機が扱いやすいよう変換したものです。

## Circomとは

回路を作成するためのツールとしてCircomを使用します。Circomは、人間が理解しやすい高級なCircom言語で書かれた回路を計算機が理解しやすい低レベルの回路に変換するコンパイラです。例えるなら、電気回路を記述するときに使うハードウェア記述言語（HDL）に近いです。

Circomは以前はJavaScriptで書かれていましたが、今はRust製になりました。現在のCircomはCircom 2と呼ばれ、以前のものは対比してCircom 1と呼ばれます。Circom 1とCircom 2は言語仕様も異なっています。Circom 1はまだメンテされていますが、将来的に廃止される予定です。

Tornado CashもCircomを使用しています。Tornado Cash ClassicはCircom 1を使って開発されましたが、このハンズオンでは最新のCircom 2を使っていきます。

## 回路の例: 因数分解

早速Circomの回路を見ていきましょう。例えば「33が2つの因数に分解できること」をゼロ知識証明したい場合、以下のような回路が考えられます。

```js
pragma circom 2.1.2;

// 回路の定義
template Multiplier2 () {  

   // シグナルの宣言  
   signal input a;  
   signal input b;  
   signal output c;  

   // 制約
   c <== a * b;  
}

// インスタンス化
component main = Multiplier2();
```

あくまで因数（1を含む）に分解できるだけで、 $33 = 1 \cdot 33$ のような分解ができるため、残念ながらRSA暗号において $n = pq$ の $p,q$ を知っていることをゼロ知識証明するような用途にはこのままだと使えません。シンプルな回路で、言語仕様を説明することには適しているため、特に変更を加えず説明していきます。

まず、`pragma`命令でCircomコンパイラのバージョンを指定しています。もし指定したバージョンの言語仕様に沿っていない機能を使えばエラーになります。この例では、最新バージョンの`2.1.2`を指定しています。

次に、`template`で回路のテンプレートを定義しています。テンプレートとは、回路を新しく定義する設計図のようなものです。後で説明しますが、`component`でインスタンス化して使います。この例では、`Multiplier2`という名前を回路を定義しています。

`template`の中では、初めにシグナルの宣言をします。シグナルとは、回路の入出力などに使われるもので、有限体 $\mathbb{F}_p$ の要素です。`input`が指定されていれば入力シグナルで、`output`が指定されていれば出力シグナルです。何も指定しなければ中間シグナルと呼ばれるものになります。シグナルはこの例では、入力シグナル`a`,`b`と出力シグナル`c`を定義しています。

シグナルの宣言の後、制約を記述します。制約とはシグナル間の条件を指定する文です。`<==`演算子や`==>`演算子を用いて記述できます。注意しなければならないのは、制約はシグナルの2次以下の関数でなければならないということです。つまり、`A`,`B`,`C`という3つのシグナルがあった場合、`A * B + C`は許されますが、`A * B * C`は許されていません。この例では、`c`を`a`と`b`を掛けた値であるとしています。` a * b ==> c`としても良いです。

最後に`component`でテンプレートから回路をインスタンス化しています。回路を実行するには、初期コンポーネントが必要で、そのコンポーネントの名前はデフォルトで`main`です。この例では、インスタンス化された`Multiplier2()`が実行されます。

## 回路のコンパイル

それでは、実際にこの回路をコンパイルしていきましょう。まず、`circuits/multiplier2`ディレクトリを作成して移動してください。そして、上記のコードをコピペして、`multiplier2.circom`というファイルを作成してください。回路を配置するディレクトリは本来どこでも良いですが、このハンズオンでは`circuits`にまとめて作業する前提で進めます。

次のコマンドを実行すると、`muliplier2.circom`をコンパイルできます。

```
circom multiplier2.circom --r1cs --wasm --sym --c
```

各オプションは次のような意味です。
- `--r1cs`: 回路のR1CS（後述）ファイルを生成する。
- `--wasm`: ウィットネス（後述）の生成に必要なWebAssemblyファイル等を生成する。
- `--sym`: 制約のデバッグに必要なファイルを生成する。
- `--c`: ウィットネスの生成に必要なC++のコード等を生成する。

以下のような結果が得られると思います。`Everything went okay`と表示されたら成功です。

```
$ circom multiplier2.circom --r1cs --wasm --sym --c
template instances: 1
non-linear constraints: 1
linear constraints: 0
public inputs: 0
public outputs: 1
private inputs: 2
private outputs: 0
wires: 4
labels: 4
Written successfully: ./multiplier2.r1cs
Written successfully: ./multiplier2.sym
Written successfully: ./multiplier2_cpp/multiplier2.cpp and ./multiplier2_cpp/multiplier2.dat
Written successfully: ./multiplier2_cpp/main.cpp, circom.hpp, calcwit.hpp, calcwit.cpp, fr.hpp, fr.cpp, fr.asm and Makefile
Written successfully: ./multiplier2_js/multiplier2.wasm
Everything went okay, circom safe
```

## Rank 1 Constraint System (R1CS)

Rank 1 Constraint System (R1CS)は、回路が生成する証明が満たさなければいけない制約の列です。より具体的には、 R1CSは3つのベクトルの列 $(a,b,c)$ で、 解を $s$ とすると、 $(s\cdot a)(s\cdot b) - s\cdot c = 0$ が成り立ちます。

今回生成された`muliplier2.r1cs`の中身を実際に見ていきましょう。R1CSファイルはバイナリファイルですが、`snarkjs r1cs info`コマンドでR1CSのメタ情報を出力でき、`snarkjs r1cs print`コマンドでR1CSを出力できます。

```
$ snarkjs r1cs info
 multiplier2.r1cs
[INFO]  snarkJS: Curve: bn-128
[INFO]  snarkJS: # of Wires: 4
[INFO]  snarkJS: # of Constraints: 1
[INFO]  snarkJS: # of Private Inputs: 2
[INFO]  snarkJS: # of Public Inputs: 0
[INFO]  snarkJS: # of Labels: 4
[INFO]  snarkJS: # of Outputs: 1
```

```
$ snarkjs r1cs print multiplier2.r1cs
[INFO]  snarkJS: [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.a ] * [ main.b ] - [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.c ] = 0
```

ここで、制約を`c <== 2 * a * b + 1337;`とすれば結果は次のようになります。

```
$ snarkjs r1cs print multiplier2.r1cs
[INFO]  snarkJS: [ 21888242871839275222246405745257275088548364400416034343698204186575808495615main.a ] * [ main.b ] - [ 1337 +21888242871839275222246405745257275088548364400416034343698204186575808495616main.c ] = 0
```

係数が2倍されていることと1337の定数が追加されていることが確認できます。

## ウィットネスの計算

ゼロ知識証明を作成するには、回路の全制約を満たすシグナルの実際の値の割り当てを決める必要があります。そのシグナルの値の割り当ての集合をウィットネス（witness）と呼びます。

具体例を見ていきましょう。入力シグナルの値が決まっていれば、中間シグナルと出力シグナルの計算は簡単にできます。今回は「33が因数分解できること」を証明したいので、入力シグナルを`a = 3`, `b = 11`としましょう。次のような`input.json`ファイルを作ってください。

```
{"a": "3", "b": "11"}
```

JavaScriptでは $2^{53}$ より大きな整数を扱うには精度が足りないため、シグナルの値には数値ではなく文字列を使います。

この`input.json`を使ってウィットネスを計算しましょう。次のコマンドを実行してください。

```
node multiplier2_js/generate_witness.js multiplier2_js/multiplier2.wasm input.json witness.wtns
```

これで、WebAssemblyを使って`witness.wtns`というウィットネスのファイルが作成されました。このファイルに、`a = 3`, `b = 11`, `c = 33`というデータが記録されています。33が因数分解できるときの全シグナルの値の割り当ての一つが求まったということです。

`wtns`ファイルはバイナリファイルですが、`snarkjs wtns export json`コマンドで中身を見ることができます。

```
$ snarkjs wtns export json witness.wtns && cat witness.json
[
 "1",
 "33",
 "3",
 "11"
]
```

このJSONファイルには、ワイヤー（wire）の計算結果が記録されています。ワイヤーのイメージとしては、入力から出力までに至るまでのステップです。ウィットネスはワイヤーの値の集合であり、中間値のスナップショットと言えます。先程の`snarkjs r1cs info`の実行結果に`[INFO]  snarkJS: # of Wires: 4`と表示されていましたが、これがその実体です。

上のファイルの各数値の意味は以下です。
- `1`: ただの定数
- `33`: パブリックの出力
- `3`,`11`: プライベートの入力

## ゼロ知識証明のセットアップ

ウィットネスが求まりましたが、ゼロ知識証明の生成をするには当然ゼロ知識証明の鍵を生成する必要があります。

### Trusted Setup

zk-SNARKsの鍵を生成するにはTrusted Setupが必要です。Trusted Setupはその名の通り、第三者を信頼するセットアップのことです。しかし、Tornado Cashのような非中央集権性を重視するプロトコルでは特定の第三者を信頼したくはないため、Multi-Party Computation (MPC)で非中央集権的にTrusted Setupを実行します。これをTrusted Setup CeremonyやMPC Ceremonyと呼びます。

### Trusted Setup Ceremony

Tornado Cashでは、2020年5月にTrusted Setup Ceremonyを行い、1000人を超えるアカウントが参加しました。このTrusted Setup Ceremonyに参加したアカウントの全員が裏切らない限りゼロ知識証明を偽造することは不可能です。逆を言えば1人でも正しい行動を取っていれば安全です。

CircomはGroth16と呼ばれるzk-SNARKプロトコルを使用しています。Groth16では回路ごとにTrusted Setupが必要です。このTrusted Setupは2つの段階に分かれており、Perpetual Powers of Tau Ceremonyと呼ばれます。1段階目は回路に依存しないセットアップで、2つ目は回路に依存するセットアップです。

Tornado CashのTrusted Setup Ceremonyは[zkUtil](https://github.com/poma/zkutil)を使用して行われましたが、このハンズオンではsnarkjsを使用します。

### Phase 1

```
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
```

```
$ snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
[DEBUG] snarkJS: Calculating First Challenge Hash
[DEBUG] snarkJS: Calculate Initial Hash: tauG1
[DEBUG] snarkJS: Calculate Initial Hash: tauG2
[DEBUG] snarkJS: Calculate Initial Hash: alphaTauG1
[DEBUG] snarkJS: Calculate Initial Hash: betaTauG1
[DEBUG] snarkJS: Blank Contribution Hash:
		786a02f7 42015903 c6c6fd85 2552d272
		912f4740 e1584761 8a86e217 f71f5419
		d25e1031 afee5853 13896444 934eb04b
		903a685b 1448b755 d56f701a fe9be2ce
[INFO]  snarkJS: First Contribution Hash:
		9e63a5f6 2b96538d aaed2372 481920d1
		a40b9195 9ea38ef9 f5f6a303 3b886516
		0710d067 c09d0961 5f928ea5 17bcdf49
		ad75abd2 c8340b40 0e3b18e9 68b4ffef
```

```
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
```

```
$ snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
Enter a random text. (Entropy): ***
[DEBUG] snarkJS: Calculating First Challenge Hash
[DEBUG] snarkJS: Calculate Initial Hash: tauG1
[DEBUG] snarkJS: Calculate Initial Hash: tauG2
[DEBUG] snarkJS: Calculate Initial Hash: alphaTauG1
[DEBUG] snarkJS: Calculate Initial Hash: betaTauG1
[DEBUG] snarkJS: processing: tauG1: 0/8191
[DEBUG] snarkJS: processing: tauG2: 0/4096
[DEBUG] snarkJS: processing: alphaTauG1: 0/4096
[DEBUG] snarkJS: processing: betaTauG1: 0/4096
[DEBUG] snarkJS: processing: betaTauG2: 0/1
[INFO]  snarkJS: Contribution Response Hash imported: 
		09297d56 9259c5f9 033074b5 42af23ca
		3ee3102e 314eaf3a 5e77543d b4ce3c7e
		cce64587 1c9a86b5 0880c878 379d1e6d
		65ca23a8 fddc7b2f 0cf3f954 0e9a1a87
[INFO]  snarkJS: Next Challenge Hash: 
		f4e97b7e ef159686 4b7eec61 d09167a0
		d9d9e693 c2cfe145 6222b13b 72ad0bc0
		2f6cc1b6 a9a61b6f fc358d51 abe05e2e
		32ce0164 2b8ec1b9 ddeba568 7557488c
```

### Phase 2

```
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
```
出力は長いので省略します。

```
snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
```

```
$ snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
[INFO]  snarkJS: Reading r1cs
[INFO]  snarkJS: Reading tauG1
[INFO]  snarkJS: Reading tauG2
[INFO]  snarkJS: Reading alphatauG1
[INFO]  snarkJS: Reading betatauG1
[INFO]  snarkJS: Circuit hash: 
		adae36e7 dc98ebda c5114789 c89889ee
		a93f0b06 027201e1 74df3d5c 52fe3b89
		c379661e bdf28d88 0a217302 bed570c6
		55c5ffc1 51f6bf7b 09008076 4d4cf201
```

```
snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v
```

```
$ snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v 
Enter a random text. (Entropy): ***
[DEBUG] snarkJS: Applying key: L Section: 0/2
[DEBUG] snarkJS: Applying key: H Section: 0/4
[INFO]  snarkJS: Circuit Hash: 
		adae36e7 dc98ebda c5114789 c89889ee
		a93f0b06 027201e1 74df3d5c 52fe3b89
		c379661e bdf28d88 0a217302 bed570c6
		55c5ffc1 51f6bf7b 09008076 4d4cf201
[INFO]  snarkJS: Contribution Hash: 
		b384c86d d68984de e245062e 28128f44
		89690435 cde637ef 524a86f7 0a6f52ee
		1673e474 ee23fa35 1cc167f5 a5f811c8
		d47b660c 79e4c578 a49b63b3 3b843bd8
```

```
snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json
```

## ゼロ知識証明の生成

```
snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json
```

## ゼロ知識証明の検証

```
snarkjs groth16 verify verification_key.json public.json proof.json
```

```
$ snarkjs groth16 verify verification_key.json public.json proof.json
[INFO]  snarkJS: OK!
```
`proof.json`が正しいことが検証でき、33が因数分解できることが証明できました。

## 演習: 3個の入力シグナルを持つ乗算器

2個の入力シグナルを持つ乗算器を参考に、3個の入力シグナルを持つ乗算器を作ってください。余裕があれば、先程作成した`multiplier2`を使用したものを作ってみてください。

<details>
<summary>ヒント</summary>
制約はシグナルの2次以下の関数でなくてはなりません。
</details>

## 演習: N個の入力シグナルを持つ乗算器

3つの入力シグナルを持つ乗算器を作りました。一般化してN個の入力シグナルを持つ乗算器を作ってください。

## 演習: 入力シグナルが真偽値かをチェックする回路

入力シグナルを1つ取り、そのシグナルが0か1であればそのシグナルをそのまま返す回路を作ってください。テンプレートの名前は`binaryCheck`としてください。


## 演習: 論理AND回路

`Multiplier2`と`binaryCheck`を利用して、2個の入力シグナルを取る論理AND回路を作ってください。

## 演習: N入力の論理AND回路（オプション）

`Multiplier2`と`binaryCheck`を利用して、N個の入力シグナルを取る論理AND回路を作ってください。

# 自作ミキサープロトコルの構成

## 基本方針

基本的には、Tornado Cash Classicの構成と似せるように作ります。ただし、Tornado Cash Classicの実装が初めて公開されたのは3年前であり、アップデートされている部分はあるものの、システム構成やツールのバージョンに古い部分があります。そのような部分はできるだけ似せないようにしています。また、ミキシングの本質に集中するために、実装するのはEtherのプールに限定し、ERC20トークンのプールは実装しないものとします。

## 演習: ミキサープロトコルの設計

ゼロ知識証明を使ってEtherの匿名送金をするためには、どのようなプロトコルの設計にすればいいか考えてみてください。入出金時の各構成要素（ユーザー、プールコントラクト、ゼロ知識証明を生成するプログラムなど）の関係性を時系列的に図に表してください。特にどの処理がオンチェーン/オフチェーンで行われるかに注意してください。

## プロトコルの全体構成


## コントラクト構成

| コントラクト                | 説明                                                               |
| --------------------------- | ------------------------------------------------------------------ |
| `TornadoCats.sol`           | プールを管理するコントラクト。入出金のインターフェース。           |
| `MerkleTreeWithHistory.sol` | ルート履歴を保持するMiMC Merkleツリーのコントラクト。              |
| `Verifier.sol`              | ゼロ知識証明の検証を行うコントラクト。ペアリングライブラリも定義。 |


## 回路構成


| 回路                | 説明                    |
| ------------------- | ----------------------- |
| `merkleTree.circom` | MiMC Merkleツリーの回路 |
| `withdraw.circom`   | 出金回路                |


# 入出金の設計

前の章でゼロ知識証明回路の作成の仕方がわかりました。さて、プールコントラクトへの入金（deposit）と出金（withdraw）はどのように設計すれば良いでしょうか。特に次の性質を満たすのが重要です。
1. 入金したアドレスと出金したアドレスが結びつかない
2. 二重に出金してプールが損をしてはいけない

性質2を満たさないことで二重に出金されてしまう攻撃を、一般的にDouble-Spending Attackと呼びます。

## 演習: 入出金操作の設計

上記性質を満たす入出金操作を考えてみてください。

## 駄目な設計例

例えば、次のような設計を考えてみましょう。あるデータ構造を $T$ とし、あるハッシュ関数を $H$ とし、ある秘密の乱数を $s$ とします。データ構造は登録/削除が行えるものであれば何でも良いですが、例えばMerkleツリーでリーフにデータを保存できるタイプのものをイメージして考えてください。そのデータに削除済みかどうかを記録します。

操作
- 入金: $H(s)$ を $T$ に登録する操作（いわゆるコミットメント）
- 出金: 「 $s$ を知っていること」をゼロ知識証明して $H(s)$ を削除する操作

これはどうでしょうか？性質2は満たしていますが、明らかに性質1を満たしておらず駄目です。入金と出金で $H(s)$ を利用しているので、入金と出金が結びついてしまいます。

## 駄目な設計例2

前の設計例では、 $H(s)$ を直接登録・削除することが問題でした。それでは、データ構造 $T$ に登録されていることを、 $H(s)$ を直接使わずにゼロ知識証明することにしたらどうでしょうか。例えば、次のような設計を考えてみましょう。

操作
- 入金: $H(s)$ を $T$ に登録する操作
- 出金: 「 $s$ を知っていてリーフである $H(s)$ が $T$ に登録されていること」をゼロ知識証明する操作

これはどうでしょうか？性質1は満たしていそうです。ゼロ知識性により $s$ も $H(s)$ も知ることは不可能なので、入金と出金が結びついていません。ただ、性質2を満たしていません。 $H(s)$の削除は行わないので、二重出金ができてしまいます。

## 良い設計例

前の設計例では、出金から入金を結びつけることは不可能でそれは良かったのですが、ある出金と別の出金が同じコミットメントに由来するものかどうかがわからないのが問題でした。例えば、次の設計を考えてみましょう。ヌリファイア（nullifier）と呼ばれる新たな乱数を導入します。ヌリファイアを $n$ として、もう一つMerkleツリー $T_n$ を用意します。今回の $T$ は普通のMerkleツリーをイメージしてください。

操作
- 入金: $H(n + s)$ を $T$ に登録する操作
- 出金: 「 $s$ と $n$ を知っていて $H(n+s)$ が $T$に登録されていること」をゼロ知識証明し、 $H(n)$ を $T_n$ に登録する操作

ヌリファイアの導入によって、ある入金に対して出金を2回できなくなりました。これで、性質1と性質2の両方を満たすことができます。


## アルゴリズムとデータ構造の選定

大まかな設計は上記のもので良いのですが、ゼロ知識証明の計算は重く、コントラクトで検証する処理の計算量が大きいと高額の手数料が発生してしまいます。そのため、ハッシュ関数やMerkleツリーはゼロ知識証明と計算量的に相性が良いものを選びたいです。

今回はハッシュ関数にPedersenハッシュ、MerkleツリーにMiMC Merkleツリーを使用します。それぞれ簡単に説明します。

## Pedersenハッシュとは

Pedersenハッシュはゼロ知識証明の回路で高速に計算できるハッシュ関数です。一般的に使われているSHA-256などの暗号学的ハッシュ関数は、わずかに異なる入力を与えるだけで全く異なる出力を生成します（アバランチ効果と呼ばれます）。Pedersenハッシュでは高速に計算できることを優先しており、この性質を持ちません。

<!-- TODO -->

## MiMC Merkleツリーとは

まず前提としてMiMCハッシュというものがあります。MiMCハッシュは乗算回数が小さくなるように設計されたハッシュ関数の一つです。「Minimal Multiplicative Complexity」が由来です。ゼロ知識証明では乗法のコストが高いため、このように設計されたMiMCハッシュが有用なのです。
 
MiMC Merkleツリーとはその名の通りMiMCハッシュを利用するMerkleツリーです。

<!-- TODO -->

# 出金回路の実装

出金回路の方針がある程度固まったところで早速実装をしていきましょう。

## 演習: シグナルの定義とコンポーネントの作成

`withdraw.circom`を作成していきます。`Withdraw`テンプレートを作成して、シグナルを定義してください。また、テンプレートをインスタンス化して`main`コンポーネントを作成してください。

## 演習: ヌリファイアのチェック

与えたヌリファイアが正しいものかチェックする処理を追加してください。

## 演習: MiMC Merkleツリーのチェック

与えたコミットメント、パス、ルートから正しいMiMC Merkleツリーを構成できるかチェックする処理を追加してください。

## 演習: 受信者・手数料・リレイヤーのチェック

受信者、手数料、リレイヤーを偽造できないように回路の制約にこれらを盛り込む必要があります。その処理を追加してください。

# コントラクト開発の基礎

プールコントラクトの実装をしていく前に、コントラクトを開発するための知識を説明します。

## コントラクト開発の流れ

このハンズオンでは、次の流れでコントラクト開発をしていきます。
1. `src`ディレクトリにコントラクトを実装する。
2. テスト（`forge test`）を実行する。
3. エラーが出ていれば1に戻る。

テストは既に実装してあるので、テストを全てパスするようなコントラクトを実装するのがゴールです。

## Solidityについて

Solidityの知識について不安のある方は[Solidityドキュメント（日本語）](https://solidity-ja.readthedocs.io/ja/latest/)を参照しながら進めてください。（minaminaoを中心に翻訳を行っています。まだ翻訳されていない部分がありますが、このハンズオンで扱う内容はカバーされています。）

## Foundryについて

Foundryについての知識は特に必要ないようにしてありますが、もし困ったことがあれば[公式ドキュメント](https://book.getfoundry.sh/)を参照してください。

# プールコントラクトの実装


## コントラクトのテスト

それではプールコントラクトの実装をしていきましょう。次のコマンドを実行するとコントラクトのテストが実行されます。全てのテストをパスしたら正しく実装されていますので、テストをパスすることを目指してください。

```
forge test -vvv
```

## 演習: `TornadoCats`コントラクトのインターフェース

`TornadoCats`はユーザーが入出金を行う際に直接操作するコントラクトです。まずは`deposit`関数と`withdraw`関数のインターフェース部分（関数の中身が空のもの）を作成してください。

`deposit`関数
- 引数
	- `bytes32 commitment`
- 戻り値
	- なし

 `withdraw`関数
 - 引数
	 - `bytes calldata proof`
	 - `bytes32 root`
	 - `bytes32 nullifierHash`
	 - `address payable recipient`
	 - `address payable relayer`
	 - `uint256 fee`
 - 戻り値
	 - なし

## 演習: `deposit`関数

`deposit`関数の中身を作ってください。

具体的には次の処理を実装してください。
- コミットメント`commitment`が既に登録されていたらリバート
- 送金額`msg.value`が送金単位`denomination`を満たしていなければリバート
- Merkleツリーにコミットメント`commitment`を挿入
- コミットメントを登録
- `Deposit`イベントの発火

## 演習: `withdraw`関数

`withdraw`関数を作ってください。

具体的には次の処理を実装してください。
- 手数料が`denomination`を超えていればリバート
- 既にノートが消費されていればリバート
- Merkleルートがルートヒストリーになければリバート
- 証明`proof`が正しいか検証して不正ならリバート
- ノートの消費を記録
- 受信者アドレスへの出金処理
- リレイヤーへの手数料送金処理
- `Withdrawal`イベントの発火

# 付録

## Tornado Cashの非中央集権性

Tornado Cashのコントラクトはイミュータブルな設計になっており、変更もアップグレードもされません。

そもそもEthereumではデプロイされたコントラクトのバイトコードは通常変更不可能です。コントラクトの挙動を変更する方法は大きく分けて3つあります。
- `CREATE2`オペコードでコントラクトをデプロイし、`SELFDESTRUCT`でコントラクトを破壊して、再度別のコントラクトをデプロイする。
- プロトコルのパラメータの変更機能を予めつけてパラメータの変更をする。
- プロキシコントラクトを利用して擬似的にアップグレードを実現する。

そのようなデプロイした後に何かしらコントラクトの挙動を変更するには、デプロイする前のコントラクトのバイトコードにその機能を含む必要があります。Tornado Cashではプロトコルパラメータの変更機能はありましたが、現在は変更できなくなっています。これは変更権限を持つアカウントを誰の所有物でもないゼロアドレスに設定したからです。また、プロキシを利用していないのでアップグレードすることは不可能です。

## Tornado Cashの稼働ネットワークと対応通貨

| ネットワーク名  | 対応通貨（シンボル）             |
| :-------------: | -------------------------------- |
|    Ethereum     | ETH, DAI, cDAI, USDC, USDT, WBTC |
| BNB Smart Chain | BNB                              |
|     Polygon     | MATIC                            |
|  Gnosis Chain   | xDAI                             |
|    Avalanche    | AVAX                             |
|    Optimism     | ETH                              |
|    Arbtirum     | ETH                              |

## Tornado Cashの主要コントラクトアドレス

| コントラクトアドレス                                                                                                  | 説明                 |
| --------------------------------------------------------------------------------------------------------------------- | -------------------- |
| [0x12D66f87A04A9E220743712cE6d9bB1B5616B8Fc](https://etherscan.io/address/0x12D66f87A04A9E220743712cE6d9bB1B5616B8Fc) | 0.1 ETHプール        |
| [0x47CE0C6eD5B0Ce3d3A51fdb1C52DC66a7c3c2936](https://etherscan.io/address/0x47CE0C6eD5B0Ce3d3A51fdb1C52DC66a7c3c2936) | 1 ETHプール          |
| [0x910Cbd523D972eb0a6f4cAe4618aD62622b39DbF](https://etherscan.io/address/0x910Cbd523D972eb0a6f4cAe4618aD62622b39DbF) | 10 ETHプール         |
| [0xA160cdAB225685dA1d56aa342Ad8841c3b53f291](https://etherscan.io/address/0xA160cdAB225685dA1d56aa342Ad8841c3b53f291) | 100 ETHプール        |
| [0xD4B88Df4D29F5CedD6857912842cff3b20C8Cfa3](https://etherscan.io/address/0xD4B88Df4D29F5CedD6857912842cff3b20C8Cfa3) | 100 DAIプール        |
| [0xFD8610d20aA15b7B2E3Be39B396a1bC3516c7144](https://etherscan.io/address/0xFD8610d20aA15b7B2E3Be39B396a1bC3516c7144) | 1,000 DAIプール      |
| [0x07687e702b410Fa43f4cB4Af7FA097918ffD2730](https://etherscan.io/address/0x07687e702b410Fa43f4cB4Af7FA097918ffD2730) | 10,000 DAIプール     |
| [0x22aaA7720ddd5388A3c0A3333430953C68f1849b](https://etherscan.io/address/0x22aaA7720ddd5388A3c0A3333430953C68f1849b) | 5,000 cDAIプール     |
| [0xBA214C1c1928a32Bffe790263E38B4Af9bFCD659](https://etherscan.io/address/0xBA214C1c1928a32Bffe790263E38B4Af9bFCD659) | 50,000 cDAIプール    |
| [0x03893a7c7463AE47D46bc7f091665f1893656003](https://etherscan.io/address/0x03893a7c7463AE47D46bc7f091665f1893656003) | 50,000 cDAIプール    |
| [0x2717c5e28cf931547B621a5dddb772Ab6A35B701](https://etherscan.io/address/0x2717c5e28cf931547B621a5dddb772Ab6A35B701) | 500,000 cDAIプール   |
| [0xD21be7248e0197Ee08E0c20D4a96DEBdaC3D20Af](https://etherscan.io/address/0xD21be7248e0197Ee08E0c20D4a96DEBdaC3D20Af) | 5,000,000 cDAIプール |
| [0x4736dCf1b7A3d580672CcE6E7c65cd5cc9cFBa9D](https://etherscan.io/address/0x4736dCf1b7A3d580672CcE6E7c65cd5cc9cFBa9D) | 100 USDCプール       |
| [0xd96f2B1c14Db8458374d9Aca76E26c3D18364307](https://etherscan.io/address/0xd96f2B1c14Db8458374d9Aca76E26c3D18364307) | 1,000 USDCプール     |
| [0x169AD27A470D064DEDE56a2D3ff727986b15D52B](https://etherscan.io/address/0x169AD27A470D064DEDE56a2D3ff727986b15D52B) | 100 USDTプール       |
| [0x0836222F2B2B24A3F36f98668Ed8F0B38D1a872f](https://etherscan.io/address/0x0836222F2B2B24A3F36f98668Ed8F0B38D1a872f) | 1,000 USDTプール     |
| [0x178169B423a011fff22B9e3F3abeA13414dDD0F1](https://etherscan.io/address/0x178169B423a011fff22B9e3F3abeA13414dDD0F1) | 0.1 WBTCプール       |
| [0x610B717796ad172B316836AC95a2ffad065CeaB4](https://etherscan.io/address/0x610B717796ad172B316836AC95a2ffad065CeaB4) | 1 WBTCプール         |
| [0xbB93e510BbCD0B7beb5A853875f9eC60275CF498](https://etherscan.io/address/0xbB93e510BbCD0B7beb5A853875f9eC60275CF498) | 10 WBTCプール        |


## Tornado Cashの主要リポジトリ一覧

GitHubでオーガナイゼーションがBANされて解除されてからアーカイブになってしまいましたが、 https://github.com/tornadocash にリポジトリがあります。最新版は https://development.tornadocash.community/tornadocash にあります（未検証）。

|                                     リポジトリ                                      | 説明                                         |
| :---------------------------------------------------------------------------------: | -------------------------------------------- |
|             [tornado-core](https://github.com/tornadocash/tornado-core)             | Tornado Cash Classic                         |
|             [tornado-nova](https://github.com/tornadocash/tornado-nova)             | Tornado Cash Nova                            |
|              [tornado-cli](https://github.com/tornadocash/tornado-cli)              | Tornado CashのCLI                            |
|          [tornado-relayer](https://github.com/tornadocash/tornado-relayer)          | Tornado Cash Classicのリレイヤークライアント |
|     [tornado-pool-relayer](https://github.com/tornadocash/tornado-pool-relayer)     | Tornado Cash Novaのリレイヤークライアント    |
|               [torn-token](https://github.com/tornadocash/torn-token)               | ガバナンストークンTORNコントラクト           |
|       [tornado-governance](https://github.com/tornadocash/tornado-governance)       | Tornado Cashのガバナンスコントラクト         |
| [tornado-anonymity-mining](https://github.com/tornadocash/tornado-anonymity-mining) | Anonymity Miningのコントラクトと回路         |
| [tornado-classic-ui](https://github.com/tornadocash/tornado-classic-ui) | Tornado Cash ClassicのUI |
|              [ui-minified](https://github.com/tornadocash/ui-minified)              | Tornado Cash ClassicのUI (minified)                    |
|         [nova-ui-minified](https://github.com/tornadocash/nova-ui-minified)         | Tornado Cash NovaのUI (minified)                       |
|                     [docs](https://github.com/tornadocash/docs)                     | Tornado Cashのドキュメント                   |


## Tornado Cash Classicのコントラクト

### コントラクト構成
| コントラクト                | 説明                                                                                                                                     |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `Tornado.sol`               | プールを管理する抽象コントラクト。入出金の共通処理とインターフェースを定めている。                                                       |
| `ETHTornado.sol`            | Ether用プールのコントラクト。`Tornado`を継承。                                                                                           |
| `ERC20Tornado.sol`          | ERC20用プールのコントラクト。`Tornado`を継承。                                                                                           |
| `cTornado.sol`              | CompoundのcToken用プールのコントラクト。`ERC20Tornado`を継承し、Tornado CashガバナンスコントラクトへCOMPトークンを送金するために特殊化。 |
| `MerkleTreeWithHistory.sol` | MiMC Merkleツリーのコントラクト。                                                                                                        |
| `Verifier.sol`              | ゼロ知識証明の検証を行うコントラクト。ペアリングライブラリも定義。                                                                       |


### `Pairing`ライブラリ

Ethereumにはペアリングのためのプリコンパイル済みコントラクトがあります。プリコンパイル済みコントラクトは`STATICCALL`オペコードを利用することを想定していますが、毎回Solidityで`staticcall`メンバを使うのは面倒であるため、プリコンパイル済みコントラクトのラッパー関数とよく使う処理一緒をまとめた`Pairing`ライブラリが作られています。

`PRIME_Q`: `21888242871839275222246405745257275088696311157297823662689037894645226208583`

`G1Point`と`G2Point`の2つの構造体が定義されています。

```solidity
  struct G1Point {
    uint256 X;
    uint256 Y;
  }
```

```solidity
  struct G2Point {
    uint256[2] X;
    uint256[2] Y;
  }
```

**関数一覧**: 
| 関数シグネチャ（引数名含む）                                                                                                                                      | 戻り型           | 説明                       |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | -------------------------- |
| `negate(G1Point memory p)`                                                                                                                                        | `G1Point memory` |                            |
| `plus(G1Point memory p1, G1Point memory p2)`                                                                                                                      | `G1Point memory` |                            |
| `scalar_mul(G1Point memory p, uint256 s)`                                                                                                                         | `G1Point memory` |                            |
| `pairing(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2, G1Point memory c1, G2Point memory c2, G1Point memory d1, G2Point memory d2)` | `bool`           | ペアリングのチェックを行う |

`plus`, `scalar_mul`, `pairing`は楕円曲線alt_bn128上の計算をするプリコンパイル済みコントラクトを使用しています。これらは、以下において追加されたものです。
- [EIP-196: Precompiled contracts for addition and scalar multiplication on the elliptic curve alt_bn128](https://eips.ethereum.org/EIPS/eip-196)
- [EIP-197: Precompiled contracts for optimal ate pairing check on the elliptic curve alt_bn128](https://eips.ethereum.org/EIPS/eip-197)

ガスコストは[EIP-1108: Reduce alt_bn128 precompile gas costs](https://eips.ethereum.org/EIPS/eip-1108)でアップデートされています。

| 名前[*](https://ethereum.github.io/execution-specs/autoapi/ethereum/paris/vm/precompiled_contracts/alt_bn128/index.html) | アドレス | 消費ガス            | 入力                          | 出力      | 説明 |
| ------------------------------------------------------------------------------------------------------------------------ | -------- | ------------------- | ----------------------------- | --------- | ---- |
| `alt_bn128_add`                                                                                                          | 0x06     | `150`               | `x1`,`y1`,`x2`,`y2`           | `x`,`y`   |      |
| `alt_bn128_mul`                                                                                                          | 0x07     | `6000`              | `x1`,`y1`,`s`                 | `x`,`y`   |      |
| `alt_bn128_pairing_check`                                                                                                | 0x08     | `34000 * k + 45000` | `x1`,`y1`,`x3`,`x2`,`y3`,`y2` | `success` |      |

`pairing`関数では、`e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1`のチェックを行います。例えば、`pairing([P1(), P1().negate()], [P2(), P2()])`は`true`です。ここで、`P1`,`P2`は次のような点です。

```solidity
    function P1() internal returns (G1Point) {
        return G1Point(1, 2);
    }
    function P2() internal returns (G2Point) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
```

### `Verifier`コントラクト

**関数一覧**:
| 関数シグネチャ（引数名含む）                               | 戻り型                | 説明                                                       |
| ---------------------------------------------------------- | --------------------- | ---------------------------------------------------------- |
| `verifyingKey()`                                           | `VerifyingKey memory` | コントラクトに埋め込みされた検証鍵を返す`pure`関数である。 |
| `verifyProof(bytes memory proof, uint256[6] memory input)` | `bool`                | 証明を検証する。                                           |


## Tornado Cash Classicのゼロ知識証明回路


### 回路構成


| 回路                | 説明 |
| ------------------- | ---- |
| `merkleTree.circom` |      |
| `withdraw.circom`   |      |

### `CommitmentHasher`テンプレート

```js
// computes Pedersen(nullifier + secret)
template CommitmentHasher() {
    signal input nullifier;
    signal input secret;
    signal output commitment;
    signal output nullifierHash;

    component commitmentHasher = Pedersen(496);
    component nullifierHasher = Pedersen(248);
    component nullifierBits = Num2Bits(248);
    component secretBits = Num2Bits(248);
    nullifierBits.in <== nullifier;
    secretBits.in <== secret;
    for (var i = 0; i < 248; i++) {
        nullifierHasher.in[i] <== nullifierBits.out[i];
        commitmentHasher.in[i] <== nullifierBits.out[i];
        commitmentHasher.in[i + 248] <== secretBits.out[i];
    }

    commitment <== commitmentHasher.out[0];
    nullifierHash <== nullifierHasher.out[0];
}
```

`nullifier`と`secret`を入力して、`commitment`と`nullifierHash`を出力しています。`nullifier`と`secret`はまず248ビットの`Num2Bits`に変換されます。その後、`Pedersen`回路を用いて、`nullifier`と`nullifier + secret`がPedersenハッシュ化されます。それぞれ、`nullifierHash`, `commitment`になります。

### `Withdraw`テンプレート

```js
// Verifies that commitment that corresponds to given secret and nullifier is included in the merkle tree of deposits
template Withdraw(levels) {
    signal input root;
    signal input nullifierHash;
    signal input recipient; // not taking part in any computations
    signal input relayer;  // not taking part in any computations
    signal input fee;      // not taking part in any computations
    signal input refund;   // not taking part in any computations
    signal private input nullifier;
    signal private input secret;
    signal private input pathElements[levels];
    signal private input pathIndices[levels];

    component hasher = CommitmentHasher();
    hasher.nullifier <== nullifier;
    hasher.secret <== secret;
    hasher.nullifierHash === nullifierHash;

    component tree = MerkleTreeChecker(levels);
    tree.leaf <== hasher.commitment;
    tree.root <== root;
    for (var i = 0; i < levels; i++) {
        tree.pathElements[i] <== pathElements[i];
        tree.pathIndices[i] <== pathIndices[i];
    }

    // Add hidden signals to make sure that tampering with recipient or fee will invalidate the snark proof
    // Most likely it is not required, but it's better to stay on the safe side and it only takes 2 constraints
    // Squares are used to prevent optimizer from removing those constraints
    signal recipientSquare;
    signal feeSquare;
    signal relayerSquare;
    signal refundSquare;
    recipientSquare <== recipient * recipient;
    feeSquare <== fee * fee;
    relayerSquare <== relayer * relayer;
    refundSquare <== refund * refund;
}
```

出力シグナルがありません。`CommitmentHasher`のインスタンスに`nullifier`と`secret`を入力して、`nullifierHash`が一致するかどうかを確かめています。`recipient`, `relayer`, `fee`, `refund`が改竄されないために追加しています。

### `MerkleTreeChecker`テンプレート

```js
// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template MerkleTreeChecker(levels) {
    signal input leaf;
    signal input root;
    signal input pathElements[levels];
    signal input pathIndices[levels];

    component selectors[levels];
    component hashers[levels];

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? leaf : hashers[i - 1].hash;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
    }

    root === hashers[levels - 1].hash;
}
```

### `DualMax`テンプレート

```js
// if s == 0 returns [in[0], in[1]]
// if s == 1 returns [in[1], in[0]]
template DualMux() {
    signal input in[2];
    signal input s;
    signal output out[2];

    s * (1 - s) === 0
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}
```

### `HashLeftRight`テンプレート

```js
// Computes MiMC([left, right])
template HashLeftRight() {
    signal input left;
    signal input right;
    signal output hash;

    component hasher = MiMCSponge(2, 1);
    hasher.ins[0] <== left;
    hasher.ins[1] <== right;
    hasher.k <== 0;
    hash <== hasher.outs[0];
}
```

## CircomLib

### `MiMCSponge`テンプレート

torenado-coreで指定されているバージョンではラウンドは固定で220でしたがが、現在はラウンドを指定できるようになっています。

### `Pedersen`テンプレート

```js
template Pedersen(n) {
    signal input in[n];
    signal output out[2];

	// 省略
}
```

### `Num2Bits`テンプレート

```js
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}
```


## Tornado Cash ClassicのTrusted Setup Ceremony

Circom 1とzkUtilを使ってTrusted Setup Ceremonyを実行しています。

1\. 回路のコンパイル

```
npx circom circuits/withdraw.circom -o build/circuits/withdraw.json
```

Circom 1で`withdraw.circom`をコンパイルし`withdraw.json`を生成します。

```
$ npx circom circuits/withdraw.circom -o build/circuits/withdraw.json
Constraints: 10000
Constraints: 20000
Constraints: 30000
Constraints: 40000
Constraints: 50000
```

2\. Trusted Setupパラメータの生成
```
zkutil setup -c build/circuits/withdraw.json -p build/circuits/withdraw.params
```

zkUtilを使用し、`withdraw.json`から出金回路のTrusted Setupパラメータ`withdraw.params`を生成します。

```
$ zkutil setup -c build/circuits/withdraw.json -p build/circuits/withdraw.params
Loading circuit from build/circuits/withdraw.json...
Generating trusted setup parameters...
Has generated 28300 points
Writing to file...
Saved parameters to build/circuits/withdraw.params
```

3\. 検証鍵の生成
```
zkutil export-keys -c build/circuits/withdraw.json -p build/circuits/withdraw.params -r build/circuits/withdraw_proving_key.json -v build/circuits/withdraw_verification_key.json
```

zkUtilを使用し、出金回路に対応するゼロ知識証明の証明鍵`withdraw_proving_key.json`と検証鍵`withdraw_verification_key.json`を生成します。

```
$ zkutil export-keys -c build/circuits/withdraw.json -p build/circuits/withdraw.params -r build/circuits/withdraw_proving_key.json -v build/circuits/withdraw_verification_key.json
Exporting build/circuits/withdraw.params...
Created build/circuits/withdraw_proving_key.json and build/circuits/withdraw_verification_key.json.
```

4\. 検証コントラクトの生成
```
zkutil generate-verifier -p build/circuits/withdraw.params -v build/circuits/Verifier.sol
```

zkUtilを使用し、出金回路に対応するゼロ知識証明の検証コントラクトを生成します。

```
$ zkutil generate-verifier -p build/circuits/withdraw.params -v build/circuits/Verifier.sol
Created build/circuits/Verifier.sol
```

`Verifier.sol`の元データは https://github.com/poma/zkutil/blob/master/src/verifier_groth.sol にあります。

5\. 検証コントラクトのバージョンの変更
```
sed -i -e 's/pragma solidity \^0.6.0/pragma solidity 0.5.17/g' ./build/circuits/Verifier.sol
```

zkUtilで生成される検証コントラクトのSolidityのバージョンが古いので置き換えます。

## Tornado Cashのガバナンス

2021年12月までは、Tornado Cashのプールに暗号資産をデポジットすることで、ガバナンストークンであるTORNを獲得できました。このマイニングをAnonymity Miningと呼びます。

他のガバナンスシステムと同様、TORNによって、Tornado Cashのプロトコルパラメータの変更やTORNの配布などは、ガバナンスによって管理されています。いわゆるDecentralized Autonomous Organization (DAO)として運用されています。

## zk-SNARK用のプリコンパイル済みコントラクト

Ethereumではzk-SNARK用にペアリングのプリコンパイル済みコントラクトが存在します。

2つの素数 $p,q$ を次に定めます。

$$ p= 21888242871839275222246405745257275088696311157297823662689037894645226208583 $$

$$ q= 21888242871839275222246405745257275088548364400416034343698204186575808495617 $$

有限体 $\mathbb{F}_p$ において、集合 $C_1$ を、

$$ C_1=\lbrace(X,Y)\in \mathbb{F}_p\times \mathbb{F}_p \mid Y^2 = X^3 + 3 \rbrace \cup \lbrace(0,0)\rbrace $$

と定義します。

$(C_1,+)$ は群であり、スカラー倍算を定義できます。

$$ n\cdot P \equiv (0,0)+ \underbrace{P+\cdots+P}_n $$

ここで、 $n$ は自然数であり、点 $P$ は $C_1$ の要素です。

$C_1$ 上の点 $(1,2)$ を $P_1$ と定義します。 $P_1$ が生成する $(C_1,+)$ の部分群を $G_1$ とすると、 $G_1$ は次数 $q$ の巡回群になることが知られています。 $G_1$ の点 $P$ に対して $n\cdot P_1 = P$ となるような最小の自然数 $n$ を $\log_{P_1}(P)$ と定義します。 $\log_{P_1}(P)$ は最大で $q-1$ です。

体 $\mathbb{F_p^2}$ を $\mathbb{F_p}[i]/(i^2+1)$ として、集合 $C_2$ を

$$ C_2=\lbrace(X,Y)\in \mathbb{F}_p^2\times \mathbb{F}_p^2 \mid Y^2 = X^3 + 3(i+9)^{-1} \rbrace \cup \lbrace(0,0)\rbrace $$

と定義します。

<!-- TODO: この体について説明 -->

$(C_2,+)$ も $(C_1,+)$ と同様に群であり、スカラー倍算を定義できます。

$C_2$ 上の点 $P_2$ を次に定義します。

$$ \begin{aligned}
P_2 \equiv & (11559732032986387107991004021392285783925812861821192530917403151452391805634 \times i \\
& +10857046999023057135944570762232829481370756359578518086990519993285655852781, \\
& 4082367875863433681332203403145435568316851327593401208105741076214120093531 \times i \\
& +8495653923123431417604973247489272438418190587263600148770280649306958101930)
\end{aligned} $$

$P_2$ が生成する $(C2, +)$ の部分群を $G_2$ とすると、 $G_2$ は $C_2$ 上で唯一の次数 $q$ の巡回群であることが知られています。 $G_2$ の点 $P$ に対して $n\cdot P_2 = P$ となるような最小の自然数 $n$ を $\log_{P_2}(P)$ と定義します。 $\log_{P_2}(P)$ は最大で $q-1$ です。

# 参考文献
- ゼロ知識証明入門
- 暗号理論と楕円曲線
- Ethereum Yellow Paper
